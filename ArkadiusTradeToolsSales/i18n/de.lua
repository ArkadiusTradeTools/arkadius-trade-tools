local localization =
{
    ATT_STR_BUYER                           = "Käufer",
    ATT_STR_SELLER                          = "Verkäufer",
    ATT_STR_GUILD                           = "Gilde",
    ATT_STR_ITEM                            = "Gegenstand",
	ATT_STR_EAPRICE                           = "EP",
    ATT_STR_PRICE                           = "Preis",
    ATT_STR_TIME                            = "Zeit",

    ATT_STR_PURCHASES                       = "Einkäufe",
    ATT_STR_SALES                           = "Verkäufe",
    ATT_STR_ITEMS                           = "Gegenstände",
    ATT_STR_DAYS                            = "Tag(e)",
    ATT_STR_NOW                             = "Jetzt",

    ATT_STR_TODAY                           = "Heute",
    ATT_STR_YESTERDAY                       = "Gestern",
    ATT_STR_TWO_DAYS_AGO                    = "Vorgestern",
    ATT_STR_THIS_WEEK                       = "Diese Woche",
    ATT_STR_LAST_WEEK                       = "Letzte Woche",
    ATT_STR_PRIOR_WEEK                      = "Vorletzte Woche",
    ATT_STR_7_DAYS                          = "7 Tage",
    ATT_STR_10_DAYS                         = "10 Tage",
    ATT_STR_14_DAYS                         = "14 Tage",
    ATT_STR_30_DAYS                         = "30 Tage",

    ATT_STR_NO_PRICE                        = "Kein Preis",
    ATT_STR_AVERAGE_PRICE                   = "Ø Preis",
    ATT_STR_OTHER_QUALITIES                 = "Andere Qualitäten",
	ATT_STR_NOTHING_FOUND                   = "<Nichts gefunden>",
    ATT_STR_STATS_TO_CHAT                   = "Statistik in Chat einfügen",
    ATT_STR_OPEN_POPUP_TOOLTIP              = "Öffne Popup Tooltip",

    ATT_FMTSTR_STATS_ITEM                   = "ATT Preis für %s: %s (%s Verkäufe / %s Gegenstände / %s Tage)",
    ATT_FMTSTR_STATS_NO_QUANTITY            = "ATT Preis für %s: %s (%s Verkäufe / %s Tage)",
    ATT_FMTSTR_STATS_MASTER_WRIT            = "ATT Preis für %s: %s (%s Verkäufe / %s Scheine / %s pro Schein / %s Tage)",
    ATT_FMTSTR_STATS_NO_SALES               = "ATT Preis für %s: Keine Verkäufe in den letzten %s Tagen.",
    ATT_FMTSTR_TOOLTIP_STATS_ITEM           = "%s Verkäufe, %s Gegenstände",
    ATT_FMTSTR_TOOLTIP_STATS_MASTER_WRIT    = "%s Verkäufe, %s Schriebscheine",
    ATT_FMTSTR_TOOLTIP_PRICE_ITEM           = "%s",
    ATT_FMTSTR_TOOLTIP_PRICE_MASTER_WRIT    = "%s (%s pro Schriebschein)",
    ATT_FMTSTR_TOOLTIP_NO_SALES             = "Keine Daten",
    ATT_FMTSTR_ANNOUNCE_SALE                = "Du hast %sx %s für %s in %s verkauft",

    ATT_STR_ENABLE_GUILD_ROSTER_EXTENSIONS  = "Erweitertes Guildenroster aktivieren",
    ATT_STR_ENABLE_TRADING_HOUSE_EXTENSIONS = "Erweiterten Gildenladen aktivieren",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS       = "Erweiterte Tooltips aktivieren",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS_GRAPH = "Zeige Graphen",
    ATT_STR_KEEP_SALES_FOR_DAYS             = "Behalte Verkäufe für x Tage",

    ATT_STR_BASE_PROFIT_MARGIN_CALC_ON      = "Gewinnspanne auf Basis von",

    ATT_STR_FILTER_TEXT_TOOLTIP             = "Textsuche nach User-, Gilden- oder Gegenstandsnamen, Gegenstandseigenschaft (z.B. präzise) oder Gegenstandsqualität (z. B. legendär)",
    ATT_STR_FILTER_SUBSTRING_TOOLTIP        = "Schalte zwischen Suche nach exaktem String oder Teilstring um. Groß- und Kleinschreibung wird in beiden Fällen ignoriert.",
    ATT_STR_FILTER_COLUMN_TOOLTIP           = "Schließe diese Spalte in die/von der Textsuche ein/aus",
}

ZO_ShallowTableCopy(localization, ArkadiusTradeTools.Modules.Sales.Localization)
