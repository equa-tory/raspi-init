# Raspi-Init
This repo was made for my dad's raspberry pi 5. Lately we often reinstall raspi os but it's boring to reinstall everything by hand so I've made this repo.

## Warning / Installation
This repo is not fully done yet so there are my instructions:
- make sure your user name is `equa`
- go into downloads folder by: `cd /home/equa/Downloads`
- install git-lfs for big files: `sudo apt install -y git-lfs`
- clone this repo: `git clone https://github.com/equa-tory/raspi-init`
- enter installation folder by: `cd raspi-init`
- make `setup` file executable by: `chmod +x setup.sh`
- run installation: `./setup.sh`
- if you need to remove `onscreen keyboard`, change `wayland` to `x11` or change `localization to russian`, the `TODO.txt` file will help you.

## Known issues
There are bugs that I know, and I know that i can fix them in future if I won't be lazy
- some folder creations, file copying and a bit more works only with `equa` user
- there is definetly better way to make this

---
# RU:
Этот репозиторий создан для Raspberry Pi 5 моего отца. В последнее время мы часто переустанавливаем Raspberry Pi, но переустанавливать всё вручную скучно, поэтому я создал этот репозиторий.

## Предупреждение / Установка
Этот репозиторий ещё не полностью готов, поэтому вот мои инструкции:
- убедитесь, что ваше имя пользователя `equa`
- перейдите в папку загрузок: `cd /home/equa/Downloads`
- установите git-lfs для больших файлов: `sudo apt install -y git-lfs`
- клонируйте этот репозиторий: `git clone https://github.com/equa-tory/raspi-init`
- войдите в папку установки: `cd raspi-init`
- сделайте файл `setup` исполняемым: `chmod +x setup.sh`
- запустите установку: `./setup.sh`
- если нужно удалить `экранную клавиатуру`, изменить `wayland` на `x11` или `localization на русский`, вам поможет файл `TODO.txt`.

## Известные проблемы
Есть ошибки, о которых я знаю, и я знаю, что смогу исправить их в будущем, если не буду лениться
- создание некоторых папок, файлов Копирование и многое другое работает только с пользователем `equa`
- есть определённо лучший способ сделать это.