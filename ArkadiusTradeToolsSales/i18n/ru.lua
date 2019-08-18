local localization =
{
    ATT_STR_BUYER                           = "Покупатель",
    ATT_STR_SELLER                          = "Продавец",
    ATT_STR_GUILD                           = "Гильдия",
    ATT_STR_ITEM                            = "Предмет",
	ATT_STR_EAPRICE                           = "шт.",
    ATT_STR_PRICE                           = "Цена",
    ATT_STR_TIME                            = "Время",

    ATT_STR_PURCHASES                       = "Покупки",
    ATT_STR_SALES                           = "Продажи",
    ATT_STR_ITEMS                           = "Предметы",
    ATT_STR_DAYS                            = "дней",
    ATT_STR_NOW                             = "сейчас",

    ATT_STR_TODAY                           = "Сегодня",
    ATT_STR_YESTERDAY                       = "Вчера",
    ATT_STR_TWO_DAYS_AGO                    = "Два дня назад",
    ATT_STR_THIS_WEEK                       = "Текущая неделя",
    ATT_STR_LAST_WEEK                       = "Прошлая неделя",
    ATT_STR_PRIOR_WEEK                      = "Предыдущая неделя",
    ATT_STR_7_DAYS                          = "7 дней",
    ATT_STR_10_DAYS                         = "10 дней",
    ATT_STR_14_DAYS                         = "14 дней",
    ATT_STR_30_DAYS                         = "30 дней",

    ATT_STR_NO_PRICE                        = "Нет цены",
    ATT_STR_AVERAGE_PRICE                   = "Средняя цена",
    ATT_STR_OTHER_QUALITIES                 = "В другом качестве",
	ATT_STR_NOTHING_FOUND                   = "<Ничего не найдено>",
    ATT_STR_STATS_TO_CHAT                   = "Статистику в чат",
    ATT_STR_OPEN_POPUP_TOOLTIP              = "Открыть всплывающую подсказку",

    ATT_FMTSTR_STATS_ITEM                   = "ATT цена для %s: %s (%s продаж / %s предметов / %s дней)",
    ATT_FMTSTR_STATS_NO_QUANTITY            = "ATT цена для %s: %s (%s продаж / %s дней)",
    ATT_FMTSTR_STATS_MASTER_WRIT            = "ATT цена для %s: %s (%s продаж / %s ваучеров / %s за ваучер / %s дней)",
    ATT_FMTSTR_STATS_NO_SALES               = "ATT цена для %s: Нет продаж за последние %s дней.",
    ATT_FMTSTR_TOOLTIP_STATS_ITEM           = "%s продаж, %s предметов",
    ATT_FMTSTR_TOOLTIP_STATS_MASTER_WRIT    = "%s продаж, %s ваучеров",
    ATT_FMTSTR_TOOLTIP_PRICE_ITEM           = "%s",
    ATT_FMTSTR_TOOLTIP_PRICE_MASTER_WRIT    = "%s (%s за один ваучер)",
    ATT_FMTSTR_TOOLTIP_NO_SALES             = "Нет данных",
    ATT_FMTSTR_ANNOUNCE_SALE                = "Вы продали %sx %s за %s в %s",

    ATT_STR_ENABLE_GUILD_ROSTER_EXTENSIONS  = "Включить Расширения для состава гильдии",
    ATT_STR_ENABLE_TRADING_HOUSE_EXTENSIONS = "Включить Расширения для магазина",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS       = "Включить Расширения для всплывающих подсказок",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS_GRAPH = "Показывать график",
    ATT_STR_KEEP_SALES_FOR_DAYS             = "Хранить историю продаж x дней",

    ATT_STR_BASE_PROFIT_MARGIN_CALC_ON      = "Расчёт прибыли основан на",

    ATT_STR_FILTER_TEXT_TOOLTIP             = "Поиск по игрокам-, гильдиям- или предметам, трейтам предметов (например, presice) или качеству предметов (например, легендарный)",
    ATT_STR_FILTER_SUBSTRING_TOOLTIP        = "Переключение между поиском по слову целиком или по части слова. Заглавные буквы игнорируются в обоих случаях.",
    ATT_STR_FILTER_COLUMN_TOOLTIP           = "Включить/Исключить эту колонку в/из поиск(а)",
}

localization["en"] =
{
    ATT_STR_STATS_TO_CHAT                   = localization["ATT_STR_STATS_TO_CHAT"],
    ATT_FMTSTR_STATS_ITEM                   = localization["ATT_FMTSTR_STATS_ITEM"],
    ATT_FMTSTR_STATS_NO_QUANTITY            = localization["ATT_FMTSTR_STATS_NO_QUANTITY"],
    ATT_FMTSTR_STATS_MASTER_WRIT            = localization["ATT_FMTSTR_STATS_MASTER_WRIT"],
    ATT_FMTSTR_STATS_NO_SALES               = localization["ATT_FMTSTR_STATS_NO_SALES"],
}

ZO_ShallowTableCopy(localization, ArkadiusTradeTools.Modules.Sales.Localization)
