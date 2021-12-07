/*!
 * COPYRIGHT (C) 2021 Emeric Grange - All Rights Reserved
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \author    Emeric Grange <emeric.grange@gmail.com>
 * \date      2021
 */

#include "FileSharingTest.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QUrl>
#include <QDebug>

/* ************************************************************************** */

FileSharingTest *FileSharingTest::instance = nullptr;

FileSharingTest *FileSharingTest::getInstance()
{
    if (instance == nullptr)
    {
        instance = new FileSharingTest();
        return instance;
    }

    return instance;
}

FileSharingTest::FileSharingTest()
{
    //
}

FileSharingTest::~FileSharingTest()
{
    //
}

/* ************************************************************************** */

bool FileSharingTest::useAsQFile(const QString &path)
{
    qDebug() << "FileSharingTest::useAsQFile(" + path + ")";

    QFile a(path);

    if (a.open(QIODevice::ReadOnly))
    {
        qDebug() << "QFile is OPEN";
        return true;
    }
    else
    {
        qWarning() << "QFile CANNOT be opened";
    }

    return false;
}

/* ************************************************************************** */
