local localization =
{
    ATT_STR_BUYER                    = "Käufer",
    ATT_STR_SELLER                   = "Verkäufer",
    ATT_STR_GUILD                    = "Gilde",
    ATT_STR_ITEM                     = "Gegenstand",
	ATT_STR_UNIT_PRICE               = "EP",
    ATT_STR_PRICE                    = "Preis",
    ATT_STR_START_TIME               = "Startzeit",
    ATT_STR_END_TIME                 = "Endzeit",
    ATT_STR_GENERATED_TIME           = "Erstellt",

    ATT_STR_EXPORTS                  = "Exporte",
    ATT_STR_EXPORT                   = "Export",

    ATT_STR_TODAY                    = "Heute",
    ATT_STR_YESTERDAY                = "Gestern",
    ATT_STR_TWO_DAYS_AGO             = "Vorgestern",
    ATT_STR_THIS_WEEK                = "Diese Woche",
    ATT_STR_LAST_WEEK                = "Letzte Woche",
    ATT_STR_PRIOR_WEEK               = "Vorletzte Woche",
    ATT_STR_7_DAYS                   = "7 Tage",
    ATT_STR_10_DAYS                  = "10 Tage",
    ATT_STR_14_DAYS                  = "14 Tage",
    ATT_STR_30_DAYS                  = "30 Tage",

    ATT_STR_KEEP_EXPORTS_FOR_DAYS    = "Behalte Exporte für x Tage",

    ATT_STR_FILTER_TEXT_TOOLTIP      = "Textsuche nach User-, Gilden- oder Gegenstandsnamen",
    ATT_STR_FILTER_SUBSTRING_TOOLTIP = "Schalte zwischen Suche nach exaktem String oder Teilstring um. Groß- und Kleinschreibung wird in beiden Fällen ignoriert.",
    ATT_STR_FILTER_COLUMN_TOOLTIP    = "Schließe diese Spalte in die/von der Textsuche ein/aus",

    ATT_STR_EXPORT_RELOAD_WARNING    = "Export saved. Please /reloadui to write to disk.",
    ATT_STR_INCLUDE_ONLY_MEMBERS     = "Only include members"
}

ZO_ShallowTableCopy(localization, ArkadiusTradeTools.Modules.Exports.Localization)
