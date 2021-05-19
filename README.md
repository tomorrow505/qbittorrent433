# qbittorrent433
Compile qbittorrent4.3.3 on ubuntu or debian.


Usage:
`wget https://raw.githubusercontent.com/tomorrow505/qbittorrent433/main/install.sh -O install.sh &>/dev/null && /bin/bash install.sh`
Then input your username and password.

When you meet info as below: type ctrl+c to exit.
```
******** Information ********
To control qBittorrent, access the Web UI at http://localhost:2021
The Web UI administrator username is: admin
The Web UI administrator password is still the default one: adminadmin
This is a security risk, please consider changing your password from program preferences.
```

Command:
`qbittorrent start|stop|restart` to start|stop|restart qbittorrent.

Plus: Mediainfo/FFmpeg/rzsz/python packages/...


Get_mediainfo_picture uasge:
```wget https://raw.githubusercontent.com/tomorrow505/qbittorrent433/main/get_mediaifno_picture.sh -O get_mediaifno_picture.sh && /bin/bash get_mediaifno_picture.sh```

Command:
`chuantu hash_of_torrent`

### 类似的加入ptpimg传图脚本: 需要在脚本所在目录新建一个config.json, 写入`{"apikey": "ptpimg的apikey"}`
```wget https://raw.githubusercontent.com/tomorrow505/qbittorrent433/main/ptpimg_upload.sh -O ptpimg_upload.sh && /bin/bash ptpimg_upload.sh```

Command:
`ptpimg hash_of_torrent`

### 2021.3.23 NEW
利用星大脚本的bluray命令截取蓝光图片上传到imgbox。
先将up_bluray_picture.sh和up_bluray_picture.sh提交到linux系统，改变up_bluray_picture.sh脚本里的python脚本的位置为实际存放位置。
`wget https://raw.githubusercontent.com/tomorrow505/qbittorrent433/main/up_bluray_picture.sh -O up_bluray_picture.sh`

`wget https://raw.githubusercontent.com/tomorrow505/qbittorrent433/main/up_bluray_picture.py -O up_bluray_picture.py`

然后给up_bluray_picture.sh执行权限，丢到/usr/bin目录下去。
chmod +x up_bluray_picture.sh && mv up_bluray_picture.sh /usr/bin

命令：up_bluray_picture.sh 蓝光文件路径(与bluray用法文件名一致)

如：`up_bluray_picture.sh "/home/shmt86/qbittorrent/download/Bang Bang.2014.BD50.Untouched BluRay.REM GERMAN.DRs/"`

提示：命令可以按tab键补全，也可以改个名字。

```bash
Submission(success=True, filepath='/log/bluray/Bang.Bang.2014.BD50.Untouched.BluRay.REM.GERMAN.DRs/screenshot09.png', filename='screenshot09.png', image_url='https://images2.imgbox.com/97/6c/0JSzOf8e_o.png', thumbnail_url='https://thumbs2.imgbox.com/97/6c/0JSzOf8e_t.png', web_url='https://imgbox.com/0JSzOf8e', gallery_url='https://imgbox.com/g/FwffNM12Pc', edit_url='https://imgbox.com/upload/edit/627561823/Sl60SFbvv3ZZPY9Z')
Submission(success=True, filepath='/log/bluray/Bang.Bang.2014.BD50.Untouched.BluRay.REM.GERMAN.DRs/screenshot04.png', filename='screenshot04.png', image_url='https://images2.imgbox.com/1b/ef/wvAaIZyZ_o.png', thumbnail_url='https://thumbs2.imgbox.com/1b/ef/wvAaIZyZ_t.png', web_url='https://imgbox.com/wvAaIZyZ', gallery_url='https://imgbox.com/g/FwffNM12Pc', edit_url='https://imgbox.com/upload/edit/627561823/Sl60SFbvv3ZZPY9Z')
Submission(success=True, filepath='/log/bluray/Bang.Bang.2014.BD50.Untouched.BluRay.REM.GERMAN.DRs/screenshot03.png', filename='screenshot03.png', image_url='https://images2.imgbox.com/22/1b/lfODM3XT_o.png', thumbnail_url='https://thumbs2.imgbox.com/22/1b/lfODM3XT_t.png', web_url='https://imgbox.com/lfODM3XT', gallery_url='https://imgbox.com/g/FwffNM12Pc', edit_url='https://imgbox.com/upload/edit/627561823/Sl60SFbvv3ZZPY9Z')
Submission(success=True, filepath='/log/bluray/Bang.Bang.2014.BD50.Untouched.BluRay.REM.GERMAN.DRs/screenshot01.png', filename='screenshot01.png', image_url='https://images2.imgbox.com/5f/2b/DFhD5WaK_o.png', thumbnail_url='https://thumbs2.imgbox.com/5f/2b/DFhD5WaK_t.png', web_url='https://imgbox.com/DFhD5WaK', gallery_url='https://imgbox.com/g/FwffNM12Pc', edit_url='https://imgbox.com/upload/edit/627561823/Sl60SFbvv3ZZPY9Z')
Submission(success=True, filepath='/log/bluray/Bang.Bang.2014.BD50.Untouched.BluRay.REM.GERMAN.DRs/screenshot05.png', filename='screenshot05.png', image_url='https://images2.imgbox.com/b4/b3/oY2IlYq4_o.png', thumbnail_url='https://thumbs2.imgbox.com/b4/b3/oY2IlYq4_t.png', web_url='https://imgbox.com/oY2IlYq4', gallery_url='https://imgbox.com/g/FwffNM12Pc', edit_url='https://imgbox.com/upload/edit/627561823/Sl60SFbvv3ZZPY9Z')
Submission(success=True, filepath='/log/bluray/Bang.Bang.2014.BD50.Untouched.BluRay.REM.GERMAN.DRs/screenshot10.png', filename='screenshot10.png', image_url='https://images2.imgbox.com/68/70/huGZe2N6_o.png', thumbnail_url='https://thumbs2.imgbox.com/68/70/huGZe2N6_t.png', web_url='https://imgbox.com/huGZe2N6', gallery_url='https://imgbox.com/g/FwffNM12Pc', edit_url='https://imgbox.com/upload/edit/627561823/Sl60SFbvv3ZZPY9Z')
Submission(success=True, filepath='/log/bluray/Bang.Bang.2014.BD50.Untouched.BluRay.REM.GERMAN.DRs/screenshot07.png', filename='screenshot07.png', image_url='https://images2.imgbox.com/c1/3a/N82CWxPj_o.png', thumbnail_url='https://thumbs2.imgbox.com/c1/3a/N82CWxPj_t.png', web_url='https://imgbox.com/N82CWxPj', gallery_url='https://imgbox.com/g/FwffNM12Pc', edit_url='https://imgbox.com/upload/edit/627561823/Sl60SFbvv3ZZPY9Z')
Submission(success=True, filepath='/log/bluray/Bang.Bang.2014.BD50.Untouched.BluRay.REM.GERMAN.DRs/screenshot02.png', filename='screenshot02.png', image_url='https://images2.imgbox.com/33/55/cn4oN8Et_o.png', thumbnail_url='https://thumbs2.imgbox.com/33/55/cn4oN8Et_t.png', web_url='https://imgbox.com/cn4oN8Et', gallery_url='https://imgbox.com/g/FwffNM12Pc', edit_url='https://imgbox.com/upload/edit/627561823/Sl60SFbvv3ZZPY9Z')
Submission(success=True, filepath='/log/bluray/Bang.Bang.2014.BD50.Untouched.BluRay.REM.GERMAN.DRs/screenshot06.png', filename='screenshot06.png', image_url='https://images2.imgbox.com/b6/d2/Wkj5zvLe_o.png', thumbnail_url='https://thumbs2.imgbox.com/b6/d2/Wkj5zvLe_t.png', web_url='https://imgbox.com/Wkj5zvLe', gallery_url='https://imgbox.com/g/FwffNM12Pc', edit_url='https://imgbox.com/upload/edit/627561823/Sl60SFbvv3ZZPY9Z')
Submission(success=True, filepath='/log/bluray/Bang.Bang.2014.BD50.Untouched.BluRay.REM.GERMAN.DRs/screenshot08.png', filename='screenshot08.png', image_url='https://images2.imgbox.com/91/95/6PxVVMzb_o.png', thumbnail_url='https://thumbs2.imgbox.com/91/95/6PxVVMzb_t.png', web_url='https://imgbox.com/6PxVVMzb', gallery_url='https://imgbox.com/g/FwffNM12Pc', edit_url='https://imgbox.com/upload/edit/627561823/Sl60SFbvv3ZZPY9Z')
[url=https://imgbox.com/0JSzOf8e][img]https://thumbs2.imgbox.com/97/6c/0JSzOf8e_t.png[/img][/url][url=https://imgbox.com/wvAaIZyZ][img]https://thumbs2.imgbox.com/1b/ef/wvAaIZyZ_t.png[/img][/url]
[url=https://imgbox.com/lfODM3XT][img]https://thumbs2.imgbox.com/22/1b/lfODM3XT_t.png[/img][/url][url=https://imgbox.com/DFhD5WaK][img]https://thumbs2.imgbox.com/5f/2b/DFhD5WaK_t.png[/img][/url]
[url=https://imgbox.com/oY2IlYq4][img]https://thumbs2.imgbox.com/b4/b3/oY2IlYq4_t.png[/img][/url][url=https://imgbox.com/huGZe2N6][img]https://thumbs2.imgbox.com/68/70/huGZe2N6_t.png[/img][/url]
[url=https://imgbox.com/N82CWxPj][img]https://thumbs2.imgbox.com/c1/3a/N82CWxPj_t.png[/img][/url][url=https://imgbox.com/cn4oN8Et][img]https://thumbs2.imgbox.com/33/55/cn4oN8Et_t.png[/img][/url]
[url=https://imgbox.com/Wkj5zvLe][img]https://thumbs2.imgbox.com/b6/d2/Wkj5zvLe_t.png[/img][/url][url=https://imgbox.com/6PxVVMzb][img]https://thumbs2.imgbox.com/91/95/6PxVVMzb_t.png[/img][/url]

```

### 新加：上传蓝光截图到ptpimg——需要在脚本所在目录新建一个config.json, 写入`{"apikey": "ptpimg的apikey"}`
先将ptpimg_bluray.py和ptpimg_bluray.sh提交到linux系统，改变ptpimg_bluray.sh脚本里的python脚本的位置为实际存放位置。
`wget https://raw.githubusercontent.com/tomorrow505/qbittorrent433/main/ptpimg_bluray.sh -O ptpimg_bluray.sh`
`wget https://raw.githubusercontent.com/tomorrow505/qbittorrent433/main/ptpimg_bluray.py -O ptpimg_bluray.py`

然后给ptpimg_bluray.sh执行权限，丢到/usr/bin目录下去。
chmod +x ptpimg_bluray.sh && mv ptpimg_bluray.sh /usr/bin

命令：ptpimg_bluray.sh 蓝光文件路径(与bluray用法文件名一致)



### 配合剧鸡的行动
----
+ 在盒子上任意目录下创建code目录：`mkdir code && cd code`

+ 获取截图代码：`wget https://raw.githubusercontent.com/tomorrow505/qbittorrent433/main/get_mediainfo_picture.py -O get_mediainfo_picture.py`

+ 创建一个tmp目录并设置为完全开放：`mkdir tmp && chmod 777 tmp`

+ 检查python版本，`python3 --version`，需要3.6+，没有的话就换个系统吧

+ 需要安装mediainfo和ffmpeg：`apt install mediainfo`，`apt install ffmpeg`.

+ 需要安装一系列的python包：

```bash
apt -y install mediainfo
apt -y install ffmpeg
apt -y install lrzsz
apt -y install python3-pip
pip3 install qbittorrent-api pymediainfo pyimgbox
```

  测试：获取当前qbittorrent客户端正在做种的一个种子的哈希值，输入：

`python3 get_mediainfo_picture.py -i {torrent-hash}`

其中torrent-hash是获取到的哈希值。

接着，在种鸡配置目录conf下新建一个seedbox.json文件，填入以下内容：

+ `{"ip": "xx.xx.xx.xx", "port": "22", "name": "root", "pass_word": "xxxxxxx", "code_path": "/home/plmsbje/code"}`

说明：以上是root登录信息不是qbittorrent登录信息，code_path就是刚才新建code路径的绝对目录。

如果没有seedbox.json，则默认是本地种鸡，会寻找本地文件，截图失败；

存在seedbox.json则会使用上面的信息与盒子进行交互，等待截图信息后完成发布。



有bug请反馈，目前通过测试的部分站点有：柠檬、猫站、套套、瓷器、馒头。



