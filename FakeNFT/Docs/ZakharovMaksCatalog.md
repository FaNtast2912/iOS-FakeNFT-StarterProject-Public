Захаров Максим Геннадьевич
Когорта: 22
Группа: 1
Эпик: Каталог
Ссылка на доску: https://github.com/users/FaNtast2912/projects/2

# Декомпозиция эпика Каталог

## Модуль 1:

#### Верстка SwiftUI

* **CatalogListView** (Каталог коллекций LazyVStack + ScrollView) (est: 5 часов; fact: x)
* **CatalogRowView** (ячейка каталога в списке) (est: 4 часа; fact: x)
* **CollectionDetailView** (экран одной коллекции) (est: 5 часов; fact: x)
* **CollectionsListView** (Коллекция NFT на экране DetailView LazyVStack + ScrollView) (est: 5 часов; fact: x)
* **NFTItemView** (ячейка NFT в коллекции конкретного NFT) (est: 4 часа; fact: x)
* **NFTRatingView** (отображение рейтинга NFT только UI) (est: 2 часа; fact: x)
* **FilterActionSheet** (фильтрация коллекций/NFT только UI) (est: 2 часа; fact: x)
* **LoadingSpinnerView** (отображение анимации загрузки только UI) (est: 2 часа; fact: x)

## Модуль 2:

#### Работа с сетью (фиктивные данные)

* **CollectionsService** (фиктивные данные) (est: 2 часа; fact: x)
* **NftsService** (фиктивные данные) (est: 2 часа; fact: x)
* Интеграция сервисов в ViewModel (Collections/Nfts) (est: 3 часа; fact: x)

#### Логика и состояние

* **CatalogViewModel** (загрузка и управление списком коллекций) (est: 3 часа; fact: x)
* **CollectionDetailViewModel** (управление данными конкретной коллекции) (est: 3 часа; fact: x)
* **FilterActionSheet** (фильтрация коллекций/NFT) (est: 2 часа; fact: x)
* **LoadingSpinnerView** (отображение анимации загрузки) (est: 2 часа; fact: x)

## Модуль 3:

#### Работа с сетью (Реальные данные)

* Рефакторинг NetworkService на async/await (est: 4 часа; fact: x)
* Загрузка реальных данных, имплементация в сервисы (est: 2 часа; fact: x)
* Добавление WebView (est: 2 часа; fact: x)
* Проверка и тестирование работы совместно с Cart (est: 2 часа; fact: x)
