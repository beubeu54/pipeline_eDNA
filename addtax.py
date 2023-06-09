import pandas as pd
from ete3 import NCBITaxa

df = pd.read_csv("LZ01.ecotag.tab", delimiter=";", header=0)

ncbi = NCBITaxa()

def get_higher_taxa(taxon_id):
    lineage = ncbi.get_lineage(taxon_id)
    ranks = ncbi.get_rank(lineage)
    names = ncbi.get_taxid_translator(lineage)
    taxonomic_ranks = {"superkingdom": "", "kingdom": "", "phylum": "", "class": "", "order": "", "family": "", "genus": "", "species": ""}
    for taxid in lineage:
        rank = ranks[taxid]
        name = names[taxid]
        if rank in taxonomic_ranks:
            taxonomic_ranks[rank] = name
    return taxonomic_ranks

def get_species_list(taxon_id):
    species_list = ncbi.get_descendant_taxa(taxon_id, intermediate_nodes=False, rank_limit="species")
    return species_list

for index, row in df.iterrows():
    taxon_id = row["taxid"]
    higher_taxa = get_higher_taxa(taxon_id)
    for rank, name in higher_taxa.items():
        df.at[index, f"{rank}_name"] = name
    if row["rank"] in ["genus", "family", "species"]:
        species_list = ncbi.get_descendant_taxa(taxon_id, intermediate_nodes=False, rank_limit="species")
        species_names = []
        for species_id in species_list:
            species_name = ncbi.get_taxid_translator([species_id])[species_id]
            # Vérifier si le nom de l'espèce contient deux mots
            if not any(char.isdigit() for char in species_name) and len(species_name.split()) == 2:
                species_names.append(species_name)
        df.at[index, "species_list"] = ", ".join(species_names)

df.to_csv("LZ01_ecotag.fasta.annotated.csv", index=False, sep=";")
