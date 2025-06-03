Захаров Максим Геннадьевич
Когорта: 22
Группа: 1
Эпик: Каталог
Ссылка на доску: https://github.com/users/FaNtast2912/projects/2

# Декомпозиция эпика Каталог

## Модуль 1:

#### Верстка SwiftUI

* **CatalogListView** (Каталог коллекций LazyVStack + ScrollView) (est: 5 часов; fact: 4)
* **CatalogRowView** (ячейка каталога в списке) (est: 4 часа; fact: 1)
* **CollectionDetailView** (экран одной коллекции) (est: 5 часов; fact: 2)
* **CollectionsListView** (Коллекция NFT на экране DetailView LazyVStack + ScrollView) (est: 5 часов; fact: 2)
* **NFTItemView** (ячейка NFT в коллекции конкретного NFT) (est: 4 часа; fact: 1)
* **NFTRatingView** (отображение рейтинга NFT только UI) (est: 2 часа; fact: 1)
* **CatalogViewModel** (загрузка и управление списком коллекций) (est: 3 часа; fact: 1)
* **CollectionDetailViewModel** (управление данными конкретной коллекции) (est: 3 часа; fact: 1)

## Модуль 2:

### Верстка

* **FilterActionSheet** (фильтрация коллекций/NFT только UI) (est: 2 часа; fact: 1)
* **ProgressHud** (отображение анимации загрузки только UI) (est: 2 часа; fact: 1)

#### Логика и состояние

* **FilterActionSheet** (фильтрация коллекций/NFT) (est: 2 часа; fact: 1)
* **ProgressHUD** (отображение анимации загрузки (Подключить общий элемент)) (est: 2 часа; fact: 1)

## Модуль 3:

### Верстка

* Добавление WebView (est: 2 часа; fact: x)
* Добавить темную тему (est: 2 часа; fact: x)

#### Логика и состояние

* Проверка и тестирование работы совместно с Cart (est: 2 часа; fact: x)

#### Работа с сетью (Реальные данные)

* Рефакторинг NetworkService на async/await (est: 4 часа; fact: 2 часа)
* Загрузка реальных данных, имплементация в сервисы (est: 2 часа; fact: 2)
* Работа с запросами (лайк/добавить в корзину) (est: 2 часа; fact: x)
