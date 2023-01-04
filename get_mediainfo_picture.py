import qbittorrentapi
import pyimgbox
import os
import subprocess
import argparse
import logging
import re
from glob import glob
from logging.handlers import RotatingFileHandler
import asyncio
import json
from pymediainfo import MediaInfo


class CapturePictureStopException(Exception):
    pass


def send_imgbox(img_loc: list=None, gallery_name: str=None):
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    task = loop.create_task(up_imgbox(img_loc, gallery_name))
    loop.run_until_complete(task)
    return task.result()


async def up_imgbox(file_paths, gallery_name):
    img_bbcode = []
    async with pyimgbox.Gallery(title=gallery_name) as gallery:
        gallery.thumb_width = 350
        async for submission in gallery.add(file_paths):
            if not submission['success']:
                logger.info('上传截图失败……')
                logger.info(f"{submission['filename']}: {submission['error']}")
            else:
                logger.info(submission)
                logger.info('上传截图成功……')
                img_bbcode.append('[url=%s][img]%s[/img][/url]' % (submission['web_url'], submission['thumbnail_url']))
    return img_bbcode


class Capture:

    info_hash: str = None
    torrent_name: str = ''
    save_path: str = ''
    abs_file_path: str = ''

    # qBittorrent 对象
    qbt: qbittorrentapi.Client = None

    # 视频的长度，视频编码，音频编码以及字幕信息
    video_duration: float = None

    def __init__(self):
        self.mediainfo = None
        self.parse_argv()

    def run(self):
        self.get_torrent_info_from_qbt()  # 从qbt中获取种子的详细信息
        self.get_info()  # 获取mediainfo和截图

    def parse_argv(self):
        """
        解析 qbt 调用命令，并从中获取到info_hash信息，并将信息写入 self.argv
        """
        parse = argparse.ArgumentParser()
        parse.add_argument('-i', help="Info hash of completed torrent")
        argv = parse.parse_args()
        self.info_hash = argv.i
        logger.info('qBittorrent 命令解析完成，info_hash值为 "%s"', self.info_hash)

    # 获取qb登录后的对象
    def get_qbt_instance(self) -> qbittorrentapi.Client:
        if not isinstance(self.qbt, qbittorrentapi.Client):
            logger.info('开始连接qBittorrent.......')
            qbt = qbittorrentapi.Client(host=qbt_address, port=qbt_port, username=qbt_user, password=qbt_password)
            qbt.auth_log_in()
            logger.info('qBittorrent 连接成功……')
            self.qbt = qbt
        return self.qbt

    def get_torrent_info_from_qbt(self):
        if os.path.exists(self.info_hash):
            self.torrent_name = os.path.basename(self.info_hash)
            self.save_path = os.path.dirname(self.info_hash)
        else:
            qbt = self.get_qbt_instance()
            logger.info('开始获取种子信息')
            torrent = qbt.torrents_info(hashes=self.info_hash)
            self.save_path = torrent[0]['save_path']
            self.torrent_name = torrent[0]['name']
        logger.info('种子名称为: %s' % self.torrent_name)

    def get_info(self):
        self.mediainfo = self.get_torrent_mediainfo()
        self.mediainfo = '[quote=iNFO][font=Courier New]%s[/font][/quote]' % self.mediainfo
        pictures = self.get_torrent_picture()
        self.mediainfo += '\n\n' + pictures
        print(self.mediainfo)
        with open(self.torrent_name+'.txt', 'w') as f:
            f.write(pictures)

    # -----------------------------------------mediainfo相关函数-------------------------------------------------
    @staticmethod
    def _mediainfo(file) -> str:
        logger.info('获取文件 %s 的Mediainfo信息 ', file)
        process = subprocess.Popen(["mediainfo", file], stdout=subprocess.PIPE)
        output, error = process.communicate()
        if not error and output != b"\n":
            output = output.decode()  # bytes -> string
            output = re.sub(re.escape(file), os.path.basename(file), output)  # Hide file path
            return output
        else:
            return ''

    def get_torrent_mediainfo(self) -> str:
        path = os.path.join(self.save_path, self.torrent_name)
        if os.path.isfile(path):  # 单文件
            self.abs_file_path = path
            return self._mediainfo(path)
        else:  # 文件夹
            test_paths = [
                os.path.join(path, '*.mkv'), os.path.join(path, '*.mp4'),
            ]
            for test_path in test_paths:
                test_path_glob = glob(test_path)
                for test_file in test_path_glob:
                    self.abs_file_path = test_file
                    return self._mediainfo(self.abs_file_path)

    # -----------------------------------------截图相关函数---------------------------------------------------
    def get_torrent_picture(self) -> str:
        logger.info('开始获取截图……')
        self.video_duration = self.get_video_info()
        picture_list = self.make_thumbnails(self.video_duration)
        logger.info('开始上传截图……')
        print(picture_list)
        urls = send_imgbox(picture_list, self.torrent_name)
        urls = [url+'\n' if urls.index(url) % 2 == 1 else url for url in urls]
        return ' '.join(urls)

    def get_video_info(self):
        media_info = MediaInfo.parse(self.abs_file_path)
        data = media_info.to_json()
        data = json.loads(data)['tracks']
        for key in data:
            if key['track_type'] == 'Video':
                self.video_duration = int(key['frame_count']) / (int(key['frame_rate'].split('.')[0]))
        return self.video_duration

    def make_thumbnails(self, video_duration):
        number = 6
        picture_list = []
        seektime = 0
        interval = int(video_duration/(number+1))
        for n in range(0, number):
            seektime += interval
            img = self.get_frame_at(seektime, n)
            if img:
                picture_list.append(img)
        return picture_list

    def get_frame_at(self, seektime, n=99):
        timestring = self.get_time_string(seektime)
        file_name = os.path.basename(self.abs_file_path)
        tmp_path = os.path.join(base_path, 'tmp')
        img_path = os.path.join(tmp_path, "{filename}-out-{d}.png".format(filename=file_name, d=n))
        command = 'ffmpeg -ss {timestring} -y -i "{file}" "-f" "image2" "-frames:v" "1" "-c:v" "png" ' \
                  '"-loglevel" "8" "{img_path}" > /dev/null 2>&1'.format(timestring=timestring, file=self.abs_file_path,
                                                        img_path=img_path)
        try:
            subprocess.call(command, shell=True)
            # os.system(command)
            if re.search('Bit depth.*?10 bits', self.mediainfo) or re.search('hdr format.*?HDR10', self.mediainfo, re.IGNORECASE):
                print('图片过大需要转换成8-bit')
                new_path = img_path.replace('.png', '-8bit.png')
                command = 'ffmpeg -i "{}" -pix_fmt rgb24 "{}" > /dev/null 2>&1'.format(img_path, new_path)
                code = os.system(command)
                os.remove(img_path)
                os.rename(new_path, img_path)
            size = os.path.getsize(img_path)/float(1024*1024)
            if size > 10:
                ratio = 100
                for i in range(1, 20):
                    ratio = 5 * (20 - i)
                    if size * ratio < 1000:
                        print('体积过大压缩至百分之%s' % str(ratio))
                        break
                from PIL import Image

                png_pil = Image.open(img_path)
                new_path = img_path.replace('.png', '-compressed.png')
                png_pil.save(new_path,"PNG",quality=ratio, optimize=True)
                os.remove(img_path)
                os.rename(new_path, img_path)
                print('图片压缩成功！！！')
            return img_path
        except Exception as exc:
            logger.info('截图失败：%s' % exc)
            return None

    @staticmethod
    def get_time_string(seconds) -> str:
        hours = int(seconds // 3600)
        minutes = int((seconds % 3600) // 60)
        seconds = int(seconds % 60)
        timestring = str(hours) + ":" + str(minutes).rjust(2, '0') + ":" + str(seconds).rjust(2, '0')
        return timestring


if __name__ == '__main__':
    # qBittorrent
    qbt_address = 'http://127.0.0.1/'
    qbt_port = 2021
    qbt_user = 'admin'
    qbt_password = 'adminadmin'

    base_path = os.path.dirname(__file__)
    fake_ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) ' \
              'Chrome/80.0.3987.106 Safari/537.36'

    # -- 日志相关 -- 不用管
    instance_log_file = os.path.join(base_path, 'capture_picture.log')
    logging_datefmt = "%m/%d/%Y %I:%M:%S %p"
    logging_format = "%(asctime)s - %(levelname)s - %(funcName)s - %(message)s"
    logFormatter = logging.Formatter(fmt=logging_format, datefmt=logging_datefmt)
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    while logger.handlers:  # Remove un-format logging in Stream, or all of messages are appearing more than once.
        logger.handlers.pop()
    if instance_log_file:
        fileHandler = RotatingFileHandler(filename=instance_log_file, mode='a', maxBytes=5 * 1024 * 1024, backupCount=2)
        fileHandler.setFormatter(logFormatter)
        logger.addHandler(fileHandler)
    consoleHandler = logging.StreamHandler()
    consoleHandler.setFormatter(logFormatter)
    logger.addHandler(consoleHandler)

    capture = Capture()
    try:
        capture.run()  # 运行
    except Exception as e:
        logger.error('程序意外终止: %s',  e)
        if not isinstance(e, CapturePictureStopException):
            raise e
