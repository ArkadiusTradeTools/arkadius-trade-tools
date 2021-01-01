local localization =
{
    ATT_STR_BUYER                    = "Покупатель",
    ATT_STR_SELLER                   = "Продавец",
    ATT_STR_GUILD                    = "Гильдия",
    ATT_STR_ITEM                     = "Предмет",
	ATT_STR_EAPRICE                  = "шт.",
    ATT_STR_PRICE                    = "Цена",
    ATT_STR_START_TIME               = "Время начала",
    ATT_STR_END_TIME                 = "Время окончания",
    ATT_STR_GENERATED_TIME           = "Создано",

    ATT_STR_EXPORTS                  = "экспорт",
    ATT_STR_EXPORT                   = "экспорт",

    ATT_STR_TODAY                    = "Сегодня",
    ATT_STR_YESTERDAY                = "Вчера",
    ATT_STR_TWO_DAYS_AGO             = "Два дня назад",
    ATT_STR_THIS_WEEK                = "Текущая неделя",
    ATT_STR_LAST_WEEK                = "Прошлая неделя",
    ATT_STR_PRIOR_WEEK               = "Предыдущая неделя",
    ATT_STR_7_DAYS                   = "7 дней",
    ATT_STR_10_DAYS                  = "10 дней",
    ATT_STR_14_DAYS                  = "14 дней",
    ATT_STR_30_DAYS                  = "30 дней",

    ATT_STR_KEEP_EXPORTS_FOR_DAYS    = "Хранить историю экспорт x дней",

    ATT_STR_FILTER_TEXT_TOOLTIP      = "Поиск по игроку-, гильдии- или предмету",
    ATT_STR_FILTER_SUBSTRING_TOOLTIP = "Переключение между поиском по слову целиком или по части слова. Заглавные буквы игнорируются в обоих случаях.",
    ATT_STR_FILTER_COLUMN_TOOLTIP    = "Включить/Исключить эту колонку в/из поиск(а)",

    ATT_STR_EXPORT_RELOAD_WARNING    = "Export saved. Please /reloadui to write to disk.",
    ATT_STR_INCLUDE_ONLY_MEMBERS     = "Only include members"
}

ZO_ShallowTableCopy(localization, ArkadiusTradeTools.Modules.Exports.Localization)
