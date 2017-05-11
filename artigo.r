# Codigo em R para importacao dos dados em formato csv e aplicacao do algoritimos para benford

# Avaliacao das execucoes/atividades dos empreendimentos da Copa de 2014 no Brasil
# Fontes dos dados: http://transparencia.gov.br/copa2014/dados/download.seam

library(benford.analysis)
library(readr)
execucao <- read_delim("~/Desktop/ILE/artigofinal/20170507_ExecucaoFinanceira2.csv", 
                       ";", escape_double = FALSE, na = "NA", 
                       trim_ws = TRUE)
result <- sqldf("select * from execucao where FlgDispensaLicitacao=1 or FlgInexibilidadeLicitacao=1")
benf_result <- benford(result$ValTotal,
                       number.of.digits = 2,
                       sign="both")
benf_result
plot(benf_result)
suspeitos <- getSuspects(benf_result, result)
duplicados <- getDuplicates(benf_result, result)
suspectstable <- suspectsTable(benf_result)

#write.csv(suspeitos, file = '~/Desktop/ILE/artigofinal/export/susp_execucao.csv')
#library("sqldf")
#sqldf("select DescObjeto from execucao where idExecucaoFinanceira=1925")
#resmem <- sqldf("select * from execucao where idExecucaoFinanceira=1925")
#write.csv(resmem, file = '~/Desktop/ILE/artigofinal/export/susp_memoria.csv')
# http://www.pichau.com.br/memoria-patriot-8gb-1x8gb-1333mhz-ddr3-psd38g13332-box
# http://www.portaltransparencia.gov.br/copa2014/cidades/execucoesFinanceirasDetalhe.seam;jsessionid=8CA8B00D1B2D1117A3F85C91666C98BD.portalcopa?execucaoFinanceira=1925&empreendimento=365

#------------------------------------------------------------------------------------------------------------
# Avaliacao dos Contratos 2014 Prefeitura de SP
#Fonte dos dados: https://www.google.com.br/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&ved=0ahUKEwiAlrjsieTTAhUFkZAKHVr0DIAQFggkMAE&url=http%3A%2F%2Fdados.prefeitura.sp.gov.br%2Fdataset%2Fbba92aa4-00e9-44ff-a0fe-3d0c98887412%2Fresource%2F4c398007-2340-42d8-9c7d-18d6a4053523%2Fdownload%2Fcontratos2014.xls&usg=AFQjCNGGsMLANxL5re-kBnsKyQv2ALr36w&cad=rja

library(benford.analysis)
library(readxl)
contratos2014_pref_sp <- read_excel("~/Desktop/ILE/artigofinal/contratos2014_pref_sp.xls", 
                                    skip = 6,
                                    range="B8:S10711")

contratos <- data.frame(orgao=contratos2014_pref_sp$`Nome do Órgão`, objeto=contratos2014_pref_sp$Objeto, fornecedor=contratos2014_pref_sp$`Fornecedor e 
                        Nome de Fantasia`, valor=contratos2014_pref_sp$`Valor(R$)`)
library(benford.analysis)
benf_result <- benford(contratos$valor,
                       number.of.digits = 2,
                       sign="both")
benf_result
plot(benf_result)
suspeitos <- getSuspects(benf_result, contratos)
duplicados <- getDuplicates(benf_result, contratos)
suspectstable <- suspectsTable(benf_result)

result <- suspeitos
result$val <- as.character(suspeitos$valor)

#susp1<-sqldf("select * from suspeitos where orgao like 'SERVIÇO FUNERÁRIO'")
#write.csv(susp1, file = '~/Desktop/ILE/artigofinal/export/susp1.csv')
#write.csv(suspeitos, file = '~/Desktop/ILE/artigofinal/export/suspeitos.csv')

#http://www.prefeitura.sp.gov.br/cidade/secretarias/upload/servicos/servico_funerario/arquivos/atas_rp/2013/2013_ata_11.pdf
#http://www.funeart.com.br/caixa-para-ossos-preta
# https://www.google.com.br/search?q=urna+plastica+para+ossos&gws_rd=cr,ssl&ei=oBsSWcinEdPywASEh6qYAQ#q=ERICAPLAST+EMBALAGENS+suspeita
