# Create a "data" directory
dir.create("Data/RNAData")

# Download the data provided by your collaborator
# using a for loop to automate this step
for(i in c("counts_raw.csv", "counts_transformed.csv", "sample_info.csv", "test_result.csv")){
  download.file(
    url = paste0("https://github.com/tavareshugo/data-carpentry-rnaseq/blob/master/data/", i, "?raw=true"),
    destfile = paste0("Data/RNAData/", i)
  )
}

# raw_cts = read.csv("Data/RNAData/counts_raw.csv")
trans_cts = read.csv("Data/RNAData/counts_transformed.csv")
sample_info = read.csv("Data/RNAData/sample_info.csv")
test_result = read.csv("Data/RNAData/test_result.csv")


# Create a matrix from our table of counts
pca_matrix <- trans_cts %>% 
  # make the "gene" column become the rownames of the table
  column_to_rownames("gene") %>% 
  # coerce to a matrix
  as.matrix() %>% 
  # transpose the matrix so that rows = samples and columns = variables
  t()


# or get the data and plot it yourself
pca_scale <- prcomp(pca_matrix, scale = TRUE)


# The PC scores are stored in the "x" value of the prcomp object
pc_scores <- as.data.frame(pca_scale$x)
pc_scores$sample = rownames(pc_scores)
pc_scores = pc_scores %>% relocate(sample)

pc_scores_comp = full_join(pc_scores, sample_info, by = "sample")

pc_loadings <- as.data.frame(pca_scale$rotation)
pc_loadings$gene = rownames(pc_loadings)
pc_loadings = pc_loadings %>% relocate(gene)

top_genes <- pc_loadings %>% 
  # select only the PCs we are interested in
  select(gene, PC1, PC2) %>%
  # convert to a "long" format
  pivot_longer(matches("PC"), names_to = "PC", values_to = "loading") %>% 
  # for each PC
  group_by(PC) %>% 
  # arrange by descending order of loading
  arrange(desc(abs(loading))) %>% 
  # take the 10 top rows
  slice(1:10) %>% 
  # pull the gene column as a vector
  pull(gene) %>% 
  # ensure only unique genes are retained
  unique()

top_loading = pc_loadings[is.element(pc_loadings$gene, top_genes), ]

trans_cts_sub = trans_cts[is.element(trans_cts$gene, top_genes), ]

write.csv(trans_cts_sub, "Data/RNAData/counts_transformed_subset.csv", row.names = F)
