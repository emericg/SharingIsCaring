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

#ifndef FILE_SHARING_TEST_H
#define FILE_SHARING_TEST_H
/* ************************************************************************** */

#include <QObject>
#include <QString>

/* ************************************************************************** */

/*!
 * \brief The FileSharingTest class
 */
class FileSharingTest: public QObject
{
    Q_OBJECT

    // Singleton
    static FileSharingTest *instance;
    FileSharingTest();
    ~FileSharingTest();

public:
    static FileSharingTest *getInstance();

    Q_INVOKABLE bool useAsQFile(const QString &path);
};

/* ************************************************************************** */
#endif // FILE_SHARING_TEST_H
