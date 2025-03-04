# Test
Тестовое приложение, которое берет данные из локального JSON-файла и отображает списком отзывы о товаре. Этот проект создан в качестве тестового задания и 
предназначен для демонстрации моего накопленного опыта в разработке для платформы iOS.

## Особенности
- В ячейку добавил:
  - Аватар пользователя. Аватар подгружается по URL, указанному в отдельном поле json-файла;
  - Имя пользователя;
  - Фотографии подгружаются по URL, указанному в отдельном поле json-файла. 
- Для загрузки фотографий реализовал ImageLoader, который работает с Operation:
  - ImageLoader умеет добавлять загрузки в список, отменять их и кешировать загруженные картинки;
  - На одну загрузку можно назначить несколько подписчиков.
- Для предзагрузки картинок в отзывах использовал UITableViewDataSourcePrefetching. 
- Добавил ячейку внизу списка с количеством отзывов:
  - У слова "отзыв" соблюдается окончание.
- Исправил подгрузку отзывов:
  -  Загрузка из репозитория обернута в GCD.
- Исправил утечку памяти в виде жесткой ссылки на ViewModel в ReviewConfig:
  - Для поиска утечек использовал Memory Graph Debugger.
- Для отображения загрузки отзывов использовал кастомный ActivityView, нарисованный и анимированный при помощи UIBezierPath, CALayer и CAAnimation.
- Реализовал Pull-To-Refresh.
- Исправил развертывание текста в отзывах с большим тестом.
- При разработке соблюдал текущую кодовую структуру. Изменения в архитектуре проекта минимальны.

## Демонстрация:

<img src="/Screenshots/1.png" width="350"/> <img src="/Screenshots/2.gif" width="350"/>
