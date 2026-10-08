# OGSR Engine для Wind of Time

Исправления для адаптации «Ветра времени» на OGSR CoP для реализации полноценной функциональности мода.

## Добавленные исправления в движок

### 1. Названия звуковых устройств

Исправлено отображение кириллицы в списке звуковых устройств и в выбранном
значении настройки `snd_device`. Названия, полученные от OpenAL в UTF-8,
преобразуются в Windows-1251, которую использует интерфейс этой адаптации.
Преобразование применяется к отображаемой подписи. Выбор и сохранение устройства
используют его исходный токен.

Файл: [`ogsr_engine/xrGame/ui/UIComboBox.cpp`](../ogsr_engine/xrGame/ui/UIComboBox.cpp).

### 2. Подсветка скриптовых обвесов

Добавлена подсветка совместимых обвесов оружейной системы Wind of Time/Shoker.
Предмет распознаётся по наличию его секции в `mod_addons_list`. Совместимость
проверяется по точным именам секций в списках `scopes` и `magazines` оружия.
При наведении на оружие подсвечиваются подходящие обвесы, при наведении на обвес
— подходящее оружие.

Файл: [`ogsr_engine/xrGame/ui/UIActorMenu.cpp`](../ogsr_engine/xrGame/ui/UIActorMenu.cpp).

### 3. Физические защиты в карточке артефакта

Добавлено отображение четырёх параметров из секции `hit_absorbation_sect`:

| Параметр | Подпись в текущем интерфейсе |
| --- | --- |
| `strike_immunity` | Удар |
| `wound_immunity` | Гашение удара |
| `explosion_immunity` | Взрыв |
| `fire_wound_immunity` | Броня |

Для каждого параметра создаётся отдельная строка, если соответствующий узел
присутствует внутри `af_params` в XML интерфейса. Выводятся ненулевые значения.
Знак, цвет и масштаб задаются штатным `UIArtefactParamItem` и параметрами строки
XML. Эта правка добавляет отображение физических защит артефактов.

Файлы:
[`ui_af_params.cpp`](../ogsr_engine/xrGame/ui/ui_af_params.cpp),
[`ui_af_params.h`](../ogsr_engine/xrGame/ui/ui_af_params.h).

Русская подпись «Взрыв» добавлена в
[`wot_artefact_protection_labels.xml`](../examples/wot/gamedata/configs/text/rus/wot_artefact_protection_labels.xml).
Для установки перевода скопируйте содержимое `examples/wot` в корень адаптации.
Для вывода защит в XML интерфейса внутри `af_params` используются узлы
`strike_immunity`, `wound_immunity`, `explosion_immunity` и `fire_wound_immunity`
с элементами `caption` и `value`.

## Сборка и перенос исправлений

1. Получите исходники ветки `main_cop_cs_wot_fixes`:

   ```console
   git clone --branch main_cop_cs_wot_fixes https://github.com/DarknessSpectre/OGSR-Engine-WoT-SP-Fixes.git
   ```

2. Запустите `Update_Components.cmd`, чтобы получить зависимости движка.
3. Откройте `Engine.sln` в Visual Studio с компонентами разработки на C++
   и Windows SDK. Выберите конфигурацию `Release` и платформу `x64`.
   Используемые инструменты сборки задаются в `OgsrBuildProps.props`:
   v143 для Visual Studio 2022, v145 для Visual Studio 2026.
4. Соберите решение. Результат находится в `bin_x64`.
