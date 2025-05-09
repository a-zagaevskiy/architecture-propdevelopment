# Список требований к внешним интеграциям

## Требования к безопасности

1. Шифрование данных

Все данные, передаваемые между системами, должны шифроваться с использованием протоколов TLS/SSL.

Помимо шифрования данных на уровне транспорта, дополнительно должны шифроваться конфиденциальные (секретные) данные (AES-256, RSA и другие).

2. Защита от атак

Не лишним будет обезопаситься от DDoS-атак и внедрить механизмы ограничения частоты запросов (Rate Limiting).

3. Протоколирование и аудит

Логирование всех запросов и ответов (без хранения конфиденциальных и секретных данных).

Если возможно, предусмотреть внедрение мониторинга подозрительной активности (SIEM-системы).

## Протоколы аутентификации и авторизации

OAuth 2.0 с использованием JWT токенов для делегированного доступа (или API-ключи с ограниченным доступом).

На транспортом уровне можно дополнительно использовать mTLS (mutual TLS).

В качестве метода авторизации подойдет комбинация RBAC и ABAC -- специальная роль для внешних интеграций с атрибутивной привязкой к ресурсам пользователей (собственников недвижимости).

## Организация взаимодействия

Т.к. в обеих внешних системах требуется взаимодействие в режиме реального времени, лучше использовать синхронные взаимодействие.

Для высоконагруженных систем с бинарной сериализацией больше подойдет использование протокола gRPC. Однако, интеграция с интеллектуальным домофонов возможно потребует дополнительной поддержки специализированных протоколов (например, SIP).
