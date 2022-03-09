#
# Скрипт для тех, кому лень лезть в каталоги и во вкладку секурити и назначать права руками
#
$UserLogin = read-host "UserName ?"

write-host "путь только без слеша на конце указывать и без логина!!"
$SourcePath1 = read-host "Путь 1?"
$SourcePath2 = read-host "Путь 2?"
$DocPath = "$SourcePath1" + "\" + "$UserLogin"

New-Item -Path $DocPath -ItemType Directory

$TrueLogin = "domain\" + "$UserLogin" # здесь ваш домен !!

$acl = Get-Acl $DocPath

# Создаем набор разрешений, который мы назначим папке
$permission = "$TrueLogin","modify","containerinherit,objectinherit","none","allow"

# Смотрим текущие ACE
$acl.Access

# ACE - Запись соответствия пользователя и его прав доступа для данного объекта

# Создаем объект ACE на основе ранее записанных разрешений
$ace = new-object security.accesscontrol.filesystemaccessrule $permission

# Вносим сделанные изменения в исходный ACL
$acl.setaccessrule($ace)
# Назначаем ACL на выбранную папку
$acl | set-acl $DocPath

#ii $DocPath

$DocPath2 = "$SourcePath2" + "\" + "$UserLogin"

New-Item -Path $DocPath2 -ItemType Directory

$TrueLogin = "domain\" + "$UserLogin" # ваш домен!!

$acl = Get-Acl $DocPath2

# Создаем набор разрешений, который мы назначим папке
$permission = "$TrueLogin","modify","containerinherit,objectinherit","none","allow"

# Смотрим текущие ACE
$acl.Access

# ACE - Запись соответствия пользователя и его прав доступа для данного объекта

# Создаем объект ACE на основе ранее записанных разрешений
$ace = new-object security.accesscontrol.filesystemaccessrule $permission

# Вносим сделанные изменения в исходный ACL
$acl.setaccessrule($ace)
# Назначаем ACL на выбранную папку
$acl | set-acl $DocPath2

#ii $DocPath2 # открыть проводник 

write-host ""
write-host "Каталог пользователю $UserLogin создан"
write-host "Путь 1"
write-host $DocPath
write-host "Путь 2"
write-host $DocPath2
