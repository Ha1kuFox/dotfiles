# pawttern

NixOS конфигурация которая использует flake и [blueprint](https://numtide.github.io/blueprint/main/) с кастомной библиотекой функций для того чтобы сделать каждый файл nix модулем или, как я их называю: **mods**.

## Установка

```bash
git clone https://github.com/Ha1kuFox/dotfiles ~/.dotfiles
cd ~/.dotfiles

# Применить конфиг(обязательно см. justfile)
just switch
```

## Структура

- **`flake.nix`**: Основной flake конфиг. [Blueprint](https://numtide.github.io/blueprint/main/) way.
- **`hosts/`**: Конфиги моих устройств
- **`modules/`**: Моды, на текущий момент в активной переработке в связи со сменой фреймворка.
- **`lib/`**: Библиотека кастомных переиспользуемых функций
- **`justfile`**: Стандартные команды
- **`formatter.nix`**: Конфигурация форматирования кода
