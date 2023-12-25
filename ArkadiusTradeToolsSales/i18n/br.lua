local localization =
{
    ATT_STR_BUYER                                      = "Comprador",
    ATT_STR_SELLER                                     = "Vendedor",
    ATT_STR_GUILD                                      = "Guilda",
    ATT_STR_ITEM                                       = "Item",
    ATT_STR_UNIT_PRICE                                 = "Preço unitário",
    ATT_STR_PRICE                                      = "Preço",
    ATT_STR_TIME                                       = "Tempo",
    ATT_STR_PURCHASES                                  = "Compras",
    ATT_STR_SALES                                      = "Vendas",
    ATT_STR_ITEMS                                      = "Artigos",
    ATT_STR_DAYS                                       = "Dia(s)",
    ATT_STR_NOW                                        = "Agora",
    ATT_STR_TODAY                                      = "Hoje",
    ATT_STR_YESTERDAY                                  = "Ontem",
    ATT_STR_TWO_DAYS_AGO                               = "Dois dias antes",
    ATT_STR_THIS_WEEK                                  = "Esta semana",
    ATT_STR_LAST_WEEK                                  = "Semana passada",
    ATT_STR_PRIOR_WEEK                                 = "Duas semanas atrás",
    ATT_STR_THIS_MONTH                                 = "Este mes",
    ATT_STR_7_DAYS                                     = "7 dias",
    ATT_STR_10_DAYS                                    = "10 dias",
    ATT_STR_14_DAYS                                    = "14 dias",
    ATT_STR_30_DAYS                                    = "30 dias",
    ATT_STR_NO_PRICE                                   = "Sem preço",
    ATT_STR_AVERAGE_PRICE                              = "Preço médio",
    ATT_STR_TOTAL                                      = "Total",
    ATT_STR_OTHER_QUALITIES                            = "Outras qualidades",
    ATT_STR_NOTHING_FOUND                              = "<Nada foi encontrado>",
    ATT_STR_STATS_TO_CHAT                              = "Vincule as informações no chat",
    ATT_STR_OPEN_POPUP_TOOLTIP                         = "Abrir dica",
    ATT_FMTSTR_STATS_ITEM                              = "Preço ATT para %s:%s (%s vendas / %s itens / %s dias)",
    ATT_FMTSTR_STATS_NO_QUANTITY                       = "Preço ATT para %s: %s (%s vendas / %s dias)",
    ATT_FMTSTR_STATS_MASTER_WRIT                       = "Preço ATT para %s: %s (%s vendas / %s comprovantes de writ / %s por comprovantes de writ / %s dias)",
    ATT_FMTSTR_STATS_NO_SALES                          = "Preço ATT para %s: Sem vendas nos últimos %s dias.",
    ATT_FMTSTR_TOOLTIP_STATS_ITEM                      = "%s vendas, %s itens",
    ATT_FMTSTR_TOOLTIP_STATS_MASTER_WRIT               = "%s vendas, %s comprovantes de writ",
    ATT_FMTSTR_TOOLTIP_PRICE_ITEM                      = "%s",
    ATT_FMTSTR_TOOLTIP_PRICE_MASTER_WRIT               = "%s (%s por comprovantes de writ)",
    ATT_FMTSTR_TOOLTIP_NO_SALES                        = "Sem vendas",
    ATT_FMTSTR_ANNOUNCE_SALE                           = "Você vendeu %sx %s por %s em %s",
    ATT_STR_ENABLE_GUILD_ROSTER_EXTENSIONS             = "Ativar extensão da lista de guilda",
    ATT_STR_ENABLE_TRADING_HOUSE_EXTENSIONS            = "Ativar a extensão da loja da guilda",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS                  = "Ativar a extensão da dica de ferramenta",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS_GRAPH            = "Exibir o gráfico",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS_CRAFTING         = "Mostrar custos de fabricação",
    ATT_STR_ENABLE_TOOLTIP_EXTENSIONS_CRAFTING_TOOLTIP = "Suportado apenas para um subconjunto de ordens mestre",
    ATT_STR_ENABLE_INVENTORY_PRICES                    = "Ativar preços em estoques",
    ATT_STR_ENABLE_INVENTORY_PRICES_WARNING            = "Pode causar pulos de quadro na primeira abertura",
    ATT_STR_KEEP_SALES_FOR_DAYS                        = "Manter as vendas por X dias",
    ATT_STR_BASE_PROFIT_MARGIN_CALC_ON                 = "Margem de lucro baseada em",
    ATT_STR_DEFAULT_DEAL_LEVEL                         = "Nível de negociação padrão",
    ATT_STR_DEFAULT_DEAL_LEVEL_TOOLTIP                 = "Define o nível de negócio padrão quando não há dados de vendas para um item",
    ATT_STR_DEAL_LEVEL_1                               = "Ruim",
    ATT_STR_DEAL_LEVEL_2                               = "OK",
    ATT_STR_DEAL_LEVEL_3                               = "Bom",
    ATT_STR_DEAL_LEVEL_4                               = "Ótimo",
    ATT_STR_DEAL_LEVEL_5                               = "Fantástico",
    ATT_STR_DEAL_LEVEL_6                               = "Alucinante!",
    ATT_STR_ENABLE_TRADING_HOUSE_AUTO_PRICING          = 'Ativar preços automáticos para listagens de comerciantes de guilda',
    ATT_STR_ENABLE_TRADING_HOUSE_AUTO_PRICING_TOOLTIP  = 'Somente UI padrão',
    ATT_STR_FILTER_TEXT_TOOLTIP                        = "Filtro textual para usuário-, guilda- ou por nomes de itens, características de itens (ex: precisos) ou por qualidade dos itens (ex: lendários)",
    ATT_STR_FILTER_SUBSTRING_TOOLTIP                   = "Muda a pesquisa da guia atual para a guia secundária ou vice-versa. Substitui os caracteres em letras maiúsculas em minúsculas.",
    ATT_STR_FILTER_COLUMN_TOOLTIP                      = "Excluir/incluir esta coluna de/para filtro de texto",
}

localization["en"] =
{
    ATT_STR_STATS_TO_CHAT        = localization["ATT_STR_STATS_TO_CHAT"],
    ATT_FMTSTR_STATS_ITEM        = localization["ATT_FMTSTR_STATS_ITEM"],
    ATT_FMTSTR_STATS_NO_QUANTITY = localization["ATT_FMTSTR_STATS_NO_QUANTITY"],
    ATT_FMTSTR_STATS_MASTER_WRIT = localization["ATT_FMTSTR_STATS_MASTER_WRIT"],
    ATT_FMTSTR_STATS_NO_SALES    = localization["ATT_FMTSTR_STATS_NO_SALES"],
}

ZO_ShallowTableCopy(localization, ArkadiusTradeTools.Modules.Sales.Localization)