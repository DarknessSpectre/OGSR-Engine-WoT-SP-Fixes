# OGSR Engine для Wind of Time

Исправления для адаптации «Ветра времени» на OGSR CoP для реализации полноценной функциональности мода.

Скачать исправления адаптации: https://github.com/DarknessSpectre/OGSR-Engine-WoT-SP-Fixes/releases/tag/3.597_CoP_WoT

# «Путь во мгле» OGSR CoP

Путь во мгле — достаточно старая сюжетная модификация на платформе S.T.A.L.K.E.R.: Зов Припяти, знакомая многим поклонникам моддинга серии.
Мод предлагает полностью новую сюжетную линию, в которой игроку предстоит взять на себя роль начинающего сталкера по прозвищу Саван.
Вместе с более опытным напарником он отправляется в Зону за секретными документами, способными пролить свет на одну давнюю тайну.
OGSR адаптация сохраняет оригинальный сюжет и атмосферу «Пути во мгле», при этом получает улучшенную графическую составляющую, технические доработки и преимущества современного движка.

Скачать адаптацию для самостоятельной сборки: https://github.com/DarknessSpectre/OGSR-Engine-WoT-SP-Fixes/releases/tag/3.597_CoP_SP_A

Скачать Standalone версию по принципу - запустил и играй:  https://github.com/DarknessSpectre/OGSR-Engine-WoT-SP-Fixes/releases/tag/3.597_CoP_SP_S


# OGSR Engine — WoT&SP Fixes

Единая сборка OGSR для адаптаций **Wind of Time** и **Spectrum Project (SP)** на «S.T.A.L.K.E.R.: Зов Припяти».

**Ветка: `main_cop_cs_wot_sp_fixes`**

Основа — официальная ветка [OGSR/OGSR-Engine:main_cop_cs](https://github.com/OGSR/OGSR-Engine/tree/main_cop_cs)
## Добавленные исправления в движок

Ссылка на на скомпилированную версию: https://github.com/DarknessSpectre/OGSR-Engine-WoT-SP-Fixes/releases/tag/3.597_CoP_WoT_SP

### 1. Русские названия звуковых устройств

Исправлено отображение кириллицы в списке устройств и в поле выбранного значения `snd_device`. Unicode-шрифт назначается обоим элементам выпадающего списка.

Названия OpenAL и токены выбора сохраняются в исходной кодировке. Для отображения используется шрифт `ui_font_utf` на основе Bender-Bold из официальной ветки `main`. Размер 18 согласован с высотой поля настроек CoP.

Файлы: [UIComboBox.h](../ogsr_engine/xrGame/ui/UIComboBox.h), [UIComboBox.cpp](../ogsr_engine/xrGame/ui/UIComboBox.cpp), [UIXmlInit.cpp](../ogsr_engine/xrGame/ui/UIXmlInit.cpp).

### 2. Подсветка скриптовых обвесов WoT/Shoker

Добавлена подсветка совместимых предметов оружейной системы WoT/Shoker. Скриптовый обвес определяется по наличию его секции в `mod_addons_list`. Совместимость проверяется по точным именам секций в `scopes` и `magazines` оружия.

- При наведении на оружие подсвечиваются подходящие обвесы.
- При наведении на обвес подсвечивается подходящее оружие.
- Штатная проверка обычных прицелов, глушителей и подствольников сохранена.

Это изменение интерфейса. Установка обвесов остаётся в скриптах оружейной системы мода. Если соответствующих секций нет, дополнительная проверка не применяется.

Файл: [UIActorMenu.cpp](../ogsr_engine/xrGame/ui/UIActorMenu.cpp).

### 3. Физические защиты в карточке артефакта

Добавлено отображение четырёх параметров из `hit_absorbation_sect`:

| Параметр | Подпись в русском интерфейсе |
| --- | --- |
| `strike_immunity` | Удар |
| `wound_immunity` | Гашение удара |
| `explosion_immunity` | Взрыв |
| `fire_wound_immunity` | Броня |

Выводятся ненулевые значения, если соответствующие строки предусмотрены внутри `af_params` в XML. Знак, цвет и масштаб задаются штатным `UIArtefactParamItem` и настройками строки.

В комплектных XML добавлены только четыре новых узла. Используются существующие иконки и оформление. Коэффициент отображения — 100, без обозначения «%»: выводится исходное поглощение, умноженное на 100. Подписи удара и взрыва добавлены для русского, английского и украинского языков.

Файлы: [ui_af_params.cpp](../ogsr_engine/xrGame/ui/ui_af_params.cpp), [ui_af_params.h](../ogsr_engine/xrGame/ui/ui_af_params.h).

### 4. Сохранение состояния машин, включая БТР

Исправлено чтение данных, которые машина передаёт серверному объекту при сохранении. `CSE_ALifeCar::load()` теперь считывает записанный `CCar::SaveNetState()` хвост пакета:

- позицию и углы;
- состояния дверей и колёс;
- здоровье машины.

Кости физической модели по-прежнему синхронизируются штатным способом напрямую. Чтение пакета машин не вызывает `data_load()`, который предназначен для другого потока и дополнительно ожидает сериализованные кости.

Правка применяется ко всем объектам `CSE_ALifeCar`, включая сюжетный БТР SP. Формат записи сохранений не изменяется. 

Физическое восстановление дверей и колёс в `CCar::RestoreNetState()` остаётся в состоянии исходного OGSR: эта правка исправляет чтение данных и не включает отключённые в базе участки восстановления заново.

Файл: [xrServer_Objects_ALife.cpp](../ogsr_engine/xrServerEntities/xrServer_Objects_ALife.cpp).

## Геймдата

За основу взята `Game/Resources_CoP_1.6.02/gamedata` из официального OGSR.

Изменены:

```text
gamedata/configs/external.ltx
gamedata/configs/ui/ui_mm_opt.xml
gamedata/configs/ui/ui_mm_opt_16.xml
```

Добавлены:

```text
gamedata/textures/ui/fonts/Bender-Bold.dds
gamedata/textures/ui/fonts/Bender-Bold.ini
gamedata/configs/ui/af_params.xml
gamedata/configs/ui/af_params_16.xml
gamedata/configs/text/rus/wot_artefact_protection_labels.xml
gamedata/configs/text/eng/wot_artefact_protection_labels.xml
gamedata/configs/text/ukr/wot_artefact_protection_labels.xml
```

Секция шрифта в `external.ltx`:

```ini
[ui_font_utf]
skip_prefix = true
shader    = font
texture   = ui\fonts\Bender-Bold
size      = 18
scale_x   = 0.35
scale_y   = 1.0
```

В двух XML настроек только для `list_snd_device/list_font` указан `font="ui_font_utf"`.

## Сборка из исходников

Нужны Git, Visual Studio 2022 или 2026 с компонентами **Desktop development with C++** и Windows SDK.

```powershell
git clone --branch main_cop_cs_wot_sp_fixes https://github.com/DarknessSpectre/OGSR-Engine-WoT-SP-Fixes.git
cd OGSR-Engine-WoT-SP-Fixes
powershell -ExecutionPolicy Bypass -File .\Restore_Build_3.597_Dependencies.ps1
powershell -ExecutionPolicy Bypass -File .\Build_3.597_x64.ps1
```

Скрипт восстановления получает точные коммиты зависимостей из [Build_3.597_dependencies.json](../Build_3.597_dependencies.json). Скрипт сборки выполняет полную пересборку `Engine.sln`, `Release | x64`, задаёт версию `3.597 (X64) WoT&SP Fixes` и копирует x64 OpenMP runtime в `bin_x64`.

Используйте короткий путь к исходникам или временный диск `subst`: имена генерируемых файлов FidelityFX длинные. Исходный `Update_Components.cmd` сохранён, но может загрузить другие версии плавающих зависимостей.
