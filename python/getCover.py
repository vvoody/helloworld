#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @author mingcheng<i.feelinglucky@gmail.com>
# @site   http://www.gracecode.com/
# @date   2010-01-22
# @revisor vvoody <wxj.g.sh@gmail.com>

import eyeD3, re, os, sys, time, urllib
 
urlread = lambda url: urllib.urlopen(url).read()
searchkeys = {}
albumcovers = {}
coverdict = {}

class getAlbumCover:
    '''从豆瓣获取专辑封面数据，并写入对应的 mp3 文件'''

    _eyeD3 = None

    # 豆瓣搜索以及专辑封面相关的 API 和格式
    _doubanSearchApi    = 'http://api.douban.com/music/subjects?q={0}&max-results=1'
    _doubanCoverPattern = 'http://t.douban.com/spic/s(\d+).jpg'
    _doubanConverAddr   = 'http://www.douban.com/lpic/s{0}.jpg'
    
    artist = '' # 演唱者
    album  = '' # 专辑名称
    title  = '' # 歌曲标题

    def __init__(self, mp3):
        self._eyeD3 = eyeD3.Tag()
        # file exists or readable?
        try:
            self._eyeD3.link(mp3)
            self.getFileInfo()
        except:
            print '读取文件错误'

    def updateCover(self, cover_file):
        '''更新专辑封面至文件'''
        try:
            self._eyeD3.removeImages()
            # cover exists or readable?
            #self._eyeD3.removeLyrics()
            #self._eyeD3.removeComments()
            self._eyeD3.addImage(3, cover_file, u'')
            self._eyeD3.update()
            return True
        except:
            print '修改文件错误'
            return False

    def getFileInfo(self):
        ''' 获取专辑信息 '''
        self.artist = self._eyeD3.getArtist().encode('utf-8')
        self.album  = self._eyeD3.getAlbum().encode('utf-8')
        self.title  = self._eyeD3.getTitle().encode('utf-8')

    def getCoverAddrFromDouban(self, keywords = ''):
        ''' 从豆瓣获取专辑封面的 URL '''
        if not len(keywords):
            keywords = self.artist + ' ' + (self.album or self.title)
        if keywords in searchkeys:
            return searchkeys[keywords]
        if self.album in albumcovers:
            return albumcovers[self.album]

        request = self._doubanSearchApi.format(urllib.quote(keywords))
        result  = urlread(request)
        if not len(result):
            return False

        match = re.compile(self._doubanCoverPattern, re.IGNORECASE).search(result)
        if match:
            cover_addr = self._doubanConverAddr.format(match.groups()[0])
            albumcovers[self.album] = searchkeys[keywords] = cover_addr
            return cover_addr
        else:
            return False


if __name__ == "__main__":
    for i in sys.argv:
        if re.search('.mp3$', i):
            print '正在处理:', i,
            handler = getAlbumCover(i)
            if handler.artist and (handler.album or handler.title):
                #print '[内容]', handler.artist, handler.title,
                cover_addr = handler.getCoverAddrFromDouban()
                if cover_addr:
                    cover_file = cover_addr.split('/')[-1]
                    if not cover_file in coverdict:
                        coverdict[cover_file] = None
                        f = file(cover_file, 'w') # Use 'wb' under Windows
                        f.write(urlread(cover_addr))
                        f.close()
                    if handler.updateCover(cover_file):
                        print '[完成]'
                    else:
                        print '[失败]'
#                    os.remove(cover_file)
                else:
                    print '[失败]'
            handler = None
            time.sleep(3) # 间隔 3s ，防止被豆瓣 Block

# vim: set et sw=4 ts=4 sts=4 fdm=marker ff=unix fenc=utf8 nobomb ft=python:
