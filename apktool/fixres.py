# -*- coding: UTF-8 -*-
import os
import re

# static fields
list_static_fields = []
data_public_xml = None


def read_file(filename, mode):
    try:
        with open(filename, mode) as f:
            return f.read()
    except Exception, e:
        print e
    return None


def write_file(filename, mode, data):
    try:
        with open(filename, mode) as f:
            f.write(data)
            return True
    except Exception, e:
        print e
    return False


def fix_res(filename):
    data = read_file(filename, 'r')
    if data is not None:
        data = re.sub(re.compile(r'=\"http://schemas.android.com/apk/res-auto\"'),
                      '=\"http://schemas.android.com/apk/com.qiyi.video\"', data)
        data = re.sub(re.compile(r' style="(.*?)"'), ' ', data)
        data = re.sub(re.compile(r' layout="(.*?)"'), ' ', data)
        write_file(filename, 'w', data)


def entry_dir_res(path):
    listdir = os.listdir(path)
    for dirname in listdir:
        filename = os.path.join(path, dirname)
        if os.path.isfile(filename):
            (filepath, tempfilename) = os.path.split(filename)
            (shotname, extension) = os.path.splitext(tempfilename)
            if extension == '.xml':
                fix_res(filename)
        if os.path.isdir(filename):
            entry_dir_res(filename)


def entry_dir(path):
    listdir = os.listdir(path)
    for dirname in listdir:
        filename = os.path.join(path, dirname)
        if os.path.isfile(filename):
            (filepath, tempfilename) = os.path.split(filename)
            (shotname, extension) = os.path.splitext(tempfilename)
            if extension == '.smali':
                read_static_fileds(filename)
        if os.path.isdir(filename):
            entry_dir(filename)


def read_static_fileds(filename):
    data = read_file(filename, 'r')
    if data is not None:
        #.field public static final t26:I = 0x7f0a0206
        list_fileds = re.findall(
            r'.field public static final (\S+):I = (0x\S{8})', data)
        for item in list_fileds:
            list_static_fields.append(item)


def read_public_xml(filename):
    print filename
    data = read_file(filename, 'r')
    return data

if __name__ == "__main__":
    #fix_res(os.path.join(os.getcwd(), 'zh.xml'))
    path = os.path.join(os.getcwd(), 'qiyi.196')
    #entry_dir(path)
    #data_public_xml = read_public_xml(
    #    os.path.join(path, 'res', 'values', 'public.xml'))
    # if data_public_xml is not None:
    # print data_public_xml
    entry_dir_res(os.path.join(path, 'res'))
