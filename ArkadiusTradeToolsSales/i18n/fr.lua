local localization =
{
    ATT_STR_BUYER                           = "Acheteur",
    ATT_STR_SELLER                          = "Vendeur",
    ATT_STR_GUILD                           = "Guilde",
    ATT_STR_ITEM                            = "Article",
	ATT_STR_EAPRICE                           = "Unitaire",
    ATT_STR_PRICE                           = "Prix",
    ATT_STR_TIME                            = "Temps",

    ATT_STR_PURCHASES                       = "Achats",
    ATT_STR_SALES                           = "Ventes",
    ATT_STR_ITEMS                           = "Articles",
    ATT_STR_DAYS                            = "Jour(s)",
    ATT_STR_NOW                             = "Maintenant",

    ATT_STR_TODAY                           = "Aujourd'hui",
    ATT_STR_YESTERDAY                       = "Hier",
    ATT_STR_TWO_DAYS_AGO                    = "Deux jours plus tôt",
    ATT_STR_THIS_WEEK                       = "Cette semaine",
    ATT_STR_LAST_WEEK                       = "La semaine dernière",
    ATT_STR_PRIOR_WEEK                      = "Il y a deux semaines",
    ATT_STR_7_DAYS                          = "7 jours",
    ATT_STR_10_DAYS                         = "10 jours",
    ATT_STR_14_DAYS                         = "14 jours",
    ATT_STR_30_DAYS                         = "30 jours",

    ATT_STR_NO_PRICE                        = "Pas de Prix",
    ATT_STR_AVERAGE_PRICE                   = "Prix moyen",
    ATT_STR_TOTAL                           = "Total",
    ATT_STR_OTHER_QUALITIES                 = "Autres qualités",
	ATT_STR_NOTHING_FOUND                   = "<Rien n'a été trouvé>",
    ATT_STR_STATS_TO_CHAT                   = "Link les informations dans le chat",
    ATT_STR_OPEN_POPUP_TOOLTIP              = "Ouvrir l'infobulle",

    ATT_FMTSTR_STATS_ITEM                   = "ATT prix pour %s: %s (%s ventes / %s acticles / %s jours)",
    ATT_FMTSTR_STATS_NO_QUANTITY            = "ATT prix pour %s: %s (%s ventes / %s jours)",
    ATT_FMTSTR_STATS_MASTER_WRIT            = "ATT prix pour %s: %s (%s ventes / %s assignats / %s par assignat / %s jours)",
    ATT_FMTSTR_STATS_NO_SALES               = "ATT prix pour %s: Pas de ventes dans les derniers %s jours.",
    ATT_FMTSTR_TOOLTIP_STATS_ITEM           = "%s ventes, %s articles",
    ATT_FMTSTR_TOOLTIP_STATS_MASTER_WRIT    = "%s ventes, %s assignats",
    ATT_FMTSTR_TOOLTIP_PRICE_ITEM           = "%s",
    ATT_FMTSTR_TOOLTIP_PRICE_MASTER_WRIT    = "%s (%s par assignats)",
    ATT_FMTSTR_TOOLTIP_NO_SALES             = "Pas de données",
    ATT_FMTSTR_ANNOUNCE_SALE                = "Vous avez vendu %sx %s pour %s dans %s",

    ATT_STR_ENABLE_GUILD_ROSTER_EXTENSIONS  = "Active l'extension de la liste de guilde",
    ATT_STR_ENABLE_TRADING_HOUSE_EXTENSIONS = "Active l'extension du magasin de guilde",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS       = "Active l'extension de l'infobulle",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS_GRAPH = "Affiche le graphe",
    ATT_STR_KEEP_SALES_FOR_DAYS             = "Garde les ventes pour x jours",

    ATT_STR_BASE_PROFIT_MARGIN_CALC_ON      = "Marge bénéficiaire basée sur",
    
    ATT_STR_DEFAULT_DEAL_LEVEL              = "Default deal level",
    ATT_STR_DEFAULT_DEAL_LEVEL_TOOLTIP      = "Sets the default deal level when there is no sales data for an item",

    ATT_STR_DEAL_LEVEL_1                    = "Bad",
    ATT_STR_DEAL_LEVEL_2                    = "OK",
    ATT_STR_DEAL_LEVEL_3                    = "Good",
    ATT_STR_DEAL_LEVEL_4                    = "Great",
    ATT_STR_DEAL_LEVEL_5                    = "Fantastic",
    ATT_STR_DEAL_LEVEL_6                    = "Mind-blowing!",

    ATT_STR_ENABLE_TRADING_HOUSE_AUTO_PRICING = 'Enable auto pricing for guild trader listings',
    ATT_STR_ENABLE_TRADING_HOUSE_AUTO_PRICING_TOOLTIP  = 'Default UI only',

    ATT_STR_FILTER_TEXT_TOOLTIP             = "Filtre textuel pour utilisteur-, guilde- or par noms des articles, traits des articles (ex: precis) ou par la qualité des articles (ex: legendaire)",
    ATT_STR_FILTER_SUBSTRING_TOOLTIP        = "Bascule la recherche de l'onglet actuel à l'onglet secondaire ou inversement. Remplace les caractères en lettre capital en minuscule.",
    ATT_STR_FILTER_COLUMN_TOOLTIP           = "Exclure/inclure cette colonne de/au filtre textuel",
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
