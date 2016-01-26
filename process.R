library(stringr)
library(plyr)
library(dplyr)
library(data.table)

######
## Read data
######
mat    <- read.csv("MAT.csv",
                  stringsAsFactors = FALSE)
invent <- read.csv("inventories_clean.csv",
                  stringsAsFactors = FALSE)
plans  <- read.csv("plans_clean.csv",
                  stringsAsFactors = FALSE)

######
## Filter data
######
mat.c  <-  dplyr::filter(mat, !is.na(slug))
mat.dc <-  data.table(mat.c)

######
## N rec, conj
######
rec   <-  mat.dc[, .N, by = "slug"]
conj  <-  mat.dc[, plyr::count(conj), by = "slug"]
conj.f  <-  conj[, .N, by = "slug"]

######
## Put it all together
######
entities <- data.frame(apply(mat[,c(1,2)],2,unique))
entities$tiene_inv  <- entities$slug %in% invent$inst_slut
entities$tiene_plan <- entities$slug %in% plans$inst_slut
ent_rec <- merge(entities, rec, by = "slug")
ent_rec_conj <- merge(ent_rec, conj.f, by = "slug")
names(ent_rec_conj) <- c("slug",
                        "dep",
                        "tiene_inventario",
                        "tiene_plan",
                        "recursos",
                        "conjuntos")

ent_rec_conj$tiene_inventario[ent_rec_conj$tiene_inventario == TRUE] <- "Si"
ent_rec_conj$tiene_inventario[ent_rec_conj$tiene_inventario == FALSE] <- "No"
ent_rec_conj$tiene_plan [ent_rec_conj$tiene_plan == TRUE] <- "Si"
ent_rec_conj$tiene_plan [ent_rec_conj$tiene_plan == FALSE] <- "No"

write.csv(ent_rec_conj,
          "dataset_presidencia.csv",
          row.names = FALSE)


final_data <- ent_rec_conj
final_data <- final_data[,-1]
final_data[,c(4,5)] <- final_data[,c(5,4)]
names(final_data) <- c("Nombre de la dependencia",
                      "¿Cuenta con Inventario de Datos?",
                      "¿Cuenta con Plan de Apertura?",
                      "Número de conjuntos de datos publicados",
                      "Número de recursos de datos publicados")
