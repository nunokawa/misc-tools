#!/usr/bin/python
# -*- coding: utf-8 -*-

import cgi
import codecs
import re
import string
import sys
from random import choice
from random import shuffle

length = 12
ascii_lowercase = True
ascii_uppercase = True
digits = True
punctuation = False

kana = {'a':'えー','b':'びー','c':'しー','d':'でぃ','e':'いー',
        'f':'えふ','g':'じー','h':'えいち','i':'あい','j':'じぇい',
        'k':'けー','l':'える','m':'えむ','n':'えぬ','o':'おー',
        'p':'ぴー','q':'きゅー','r':'あーる','s':'えす','t':'てぃー',
        'u':'ゆー','v':'ぶい','w':'だるぶゆー','x':'えっくす','y':'わい','z':'ぜっと',
        'A':'エー','B':'ビー','C':'シー','D':'ディ','E':'イー',
        'F':'エフ','G':'ジー','H':'エイチ','I':'アイ','J':'ジェイ',
        'K':'ケー','L':'エル','M':'エム','N':'エヌ','O':'オー',
        'P':'ピー','Q':'キュー','R':'アール','S':'エス','T':'ティー',
        'U':'ユー','V':'ブイ','W':'ダブルユー','X':'エックス','Y':'ワイ','Z':'ゼット',
        '0':'ぜろ','1':'いち','2':'に','3':'さん','4':'よん',
        '5':'ご','6':'ろく','7':'なな','8':'はち','9':'きゅう',
        '!':'びっくりマーク','"':'ダブルクォート','#':'シャープ','$':'ドルマーク','%':'パーセント',
        '&':'アンド','\'':'シングルクォート','(':'左かっこ',')':'右かっこ','*':'アスタリスク',
        '+':'プラス',',':'カンマ','-':'ハイフン','.':'ピリオド','/':'スラッシュ',
        ':':'コロン',';':'セミコロン','<':'小なり','=':'イコール','>':'大なり',
        '?':'はてなマーク','@':'アットマーク','[':'左角かっこ','\\':'バックスラッシュ',']':'右角かっこ',
        '^':'キャレット','_':'アンダースコア','`':'バッククォート','{':'左波かっこ','|':'縦線',
        '}':'右波かっこ','~':'チルダ' }

# abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
# 0123456789
# !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~


def pass_gen():
    char_list = ""
    passwd_list = ""

    if ascii_lowercase:
        char_list = char_list + string.ascii_lowercase
    if ascii_uppercase:
        char_list = char_list + string.ascii_uppercase
    if digits:
        char_list = char_list + string.digits
    if punctuation:
        passwd_list = "".join([choice(char_list) for i in range(length-(length/10+1))]) + "".join([choice(string.punctuation) for i in range(length/10+1)])
    else:
        passwd_list = "".join([choice(char_list) for i in range(length)])

    passwd = list(passwd_list)
    shuffle(passwd)
    return "".join(passwd)

def main(passwd):

    yomikana = ""

    sys.stdout = codecs.getwriter('utf_8')(sys.stdout)

    print "Content-Type: text/html; charset=utf-8"
    print
    print "<html><body>"
    for key in list(passwd):
        yomikana = yomikana + kana[key].decode('utf-8') + ", "
    passwd = re.sub("<", "&lt;", passwd)
    passwd = re.sub(">", "&gt;", passwd)
    print passwd
    print "<br>\n" + yomikana
#    for key in kana.keys():
#        print key + " " + kana[key].decode('utf-8')
    print "</body></html>"

if __name__ == "__main__":
    passwd = pass_gen()
    main(passwd)
