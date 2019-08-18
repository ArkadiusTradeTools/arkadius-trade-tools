local localization =
{
    ATT_STR_BUYER                           = "Buyer",
    ATT_STR_SELLER                          = "Seller",
    ATT_STR_GUILD                           = "Guild",
    ATT_STR_ITEM                            = "Item",
    ATT_STR_PRICE                           = "Price",
    ATT_STR_TIME                            = "Time",

    ATT_STR_PURCHASES                       = "Purchases",
    ATT_STR_SALES                           = "Sales",
    ATT_STR_ITEMS                           = "Items",
    ATT_STR_DAYS                            = "day(s)",
    ATT_STR_NOW                             = "now",

    ATT_STR_TODAY                           = "Today",
    ATT_STR_YESTERDAY                       = "Yesterday",
    ATT_STR_TWO_DAYS_AGO                    = "Two days ago",
    ATT_STR_THIS_WEEK                       = "This week",
    ATT_STR_LAST_WEEK                       = "Last week",
    ATT_STR_PRIOR_WEEK                      = "Prior week",
    ATT_STR_7_DAYS                          = "7 days",
    ATT_STR_10_DAYS                         = "10 days",
    ATT_STR_14_DAYS                         = "14 days",
    ATT_STR_30_DAYS                         = "30 days",

    ATT_STR_NO_PRICE                        = "No price",
    ATT_STR_AVERAGE_PRICE                   = "Avg price",
    ATT_STR_OTHER_QUALITIES                 = "Other qualities",
	ATT_STR_NOTHING_FOUND                   = "<Nothing found>",
    ATT_STR_STATS_TO_CHAT                   = "Stats to Chat",
    ATT_STR_OPEN_POPUP_TOOLTIP              = "Open Popup Tooltip",

    ATT_FMTSTR_STATS_ITEM                   = "ATT price for %s: %s (%s sales / %s items / %s days)",
    ATT_FMTSTR_STATS_NO_QUANTITY            = "ATT price for %s: %s (%s sales / %s days)",
    ATT_FMTSTR_STATS_MASTER_WRIT            = "ATT price for %s: %s (%s sales / %s vouchers / %s per voucher / %s days)",
    ATT_FMTSTR_STATS_NO_SALES               = "ATT price for %s: No sales within last %s days.",
    ATT_FMTSTR_TOOLTIP_STATS_ITEM           = "%s sales, %s items",
    ATT_FMTSTR_TOOLTIP_STATS_MASTER_WRIT    = "%s sales, %s writ vouchers",
    ATT_FMTSTR_TOOLTIP_PRICE_ITEM           = "%s",
    ATT_FMTSTR_TOOLTIP_PRICE_MASTER_WRIT    = "%s (%s per writ voucher)",
    ATT_FMTSTR_TOOLTIP_NO_SALES             = "No data",
    ATT_FMTSTR_ANNOUNCE_SALE                = "You sold %sx %s for %s in %s",

    ATT_STR_ENABLE_GUILD_ROSTER_EXTENSIONS  = "Enable guild roster extensions",
    ATT_STR_ENABLE_TRADING_HOUSE_EXTENSIONS = "Enable guild store extensions",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS       = "Enable tooltip extensions",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS_GRAPH = "Show graph",
    ATT_STR_KEEP_SALES_FOR_DAYS             = "Keep sales for x days",

    ATT_STR_BASE_PROFIT_MARGIN_CALC_ON      = "Profit margin based on",

    ATT_STR_FILTER_TEXT_TOOLTIP             = "Text search for user-, guild- or item names, item traits (e. g. precise) or item quality (e. g. legendary)",
    ATT_STR_FILTER_SUBSTRING_TOOLTIP        = "Toggle between search for exact strings or substrings. Case sensitivity is ignored in both cases.",
    ATT_STR_FILTER_COLUMN_TOOLTIP           = "Exclude/include this column from/to the text search",
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
