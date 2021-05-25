import argparse
import os
import asyncio
import pyimgbox


def send_imgbox(img_loc: list=None, gallery_name: str=None):
    loop = asyncio.get_event_loop()
    task = loop.create_task(up_imgbox(img_loc, gallery_name))
    loop.run_until_complete(task)
    return task.result()


async def up_imgbox(file_paths, gallery_name):
    img_bbcode = []
    async with pyimgbox.Gallery(title=gallery_name) as gallery:
        gallery.thumb_width = 350
        async for submission in gallery.add(file_paths):
            if not submission['success']:
                print(f"{submission['filename']}: {submission['error']}")
            else:
                print(submission)
                img_bbcode.append('[url=%s][img]%s[/img][/url]' % (submission['web_url'], submission['thumbnail_url']))
    return img_bbcode


def parse_argv():
    parse = argparse.ArgumentParser()
    parse.add_argument('-p', help="Path of blu-ray pictures")
    argv = parse.parse_args()
    path = argv.p

    return path


def get_img_paths_from_path(path):
    img_paths = []
    files = os.listdir(path)
    files.sort()
    for file in files:
        file_path = os.path.join(path, file)
        if file_path.endswith("png"):
            img_paths.append(file_path)

    return img_paths


if __name__=="__main__":
    files_path = parse_argv()
    img_paths = get_img_paths_from_path(files_path)
    gallery_name = os.path.basename(files_path)
    if not gallery_name:
        gallery_name = files_path.split('/')[-1].split('\\')[-1]
    urls = send_imgbox(img_loc=img_paths, gallery_name=gallery_name)
    urls = [url+'\n' if urls.index(url) % 2 == 1 else url for url in urls]
    print(' '.join(urls))
