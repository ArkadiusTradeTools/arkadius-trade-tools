local localization =
{
    ATT_STR_BUYER                    = "Acheteur",
    ATT_STR_SELLER                   = "Vendeur",
    ATT_STR_GUILD                    = "Guilde",
    ATT_STR_ITEM                     = "Article",
	ATT_STR_UNIT_PRICE               = "Prix unitaire",
    ATT_STR_PRICE                    = "Prix",
    ATT_STR_START_TIME               = "Heure de début",
    ATT_STR_END_TIME                 = "Heure de fin",
    ATT_STR_GENERATED_TIME           = "Heure de création",
    ATT_STR_EXPORTS                  = "Exportations",
    ATT_STR_EXPORT                   = "Exporter",
    ATT_STR_TODAY                    = "Aujourd'hui",
    ATT_STR_YESTERDAY                = "Hier",
    ATT_STR_TWO_DAYS_AGO             = "Deux jours plus tôt",
    ATT_STR_THIS_WEEK                = "Cette semaine",
    ATT_STR_LAST_WEEK                = "La semaine dernière",
    ATT_STR_PRIOR_WEEK               = "Il y a deux semaines",
    ATT_STR_THIS_MONTH               = "Ce mois-ci",
    ATT_STR_7_DAYS                   = "7 jours",
    ATT_STR_10_DAYS                  = "10 jours",
    ATT_STR_14_DAYS                  = "14 jours",
    ATT_STR_30_DAYS                  = "30 jours",
    ATT_STR_KEEP_EXPORTS_FOR_DAYS    = "Garder l'exportation pour x jours",
    ATT_STR_FILTER_TEXT_TOOLTIP      = "Filtre textuel pour l'utilisiteur-, la guilde- ou par nom d'articles",
    ATT_STR_FILTER_SUBSTRING_TOOLTIP = "Bascule la recherche de l'onglet actuel à l'onglet secondaire ou inversement. Remplace les caractères en lettre capital en minuscule.",
    ATT_STR_FILTER_COLUMN_TOOLTIP    = "Exclure/inclure cette colonne de/au Filtre textuel",
    ATT_STR_EXPORT_RELOAD_WARNING    = "Export saved. Please /reloadui to write to disk.",
    ATT_STR_INCLUDE_ONLY_MEMBERS     = "Only include members"
}

ZO_ShallowTableCopy(localization, ArkadiusTradeTools.Modules.Exports.Localization)
