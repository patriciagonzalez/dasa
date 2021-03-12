# dasa
Pipeline de bioinformática germinativo

Autora: Patrícia 

Os arquivos originais devem ser adicionados na pasta data/original_files. 

O arquivo "get_RefGenoma.sh" baixa o arquivo do genoma de referência hg38 ("hg38.fa") e salva no diretório ../data/reference_genome que o mesmo script cria. 

O script "do_bwa_alignment.sh" alocado no diretório scr/ realiza os seguintes processos: 
1- Análises de controle de qualidade com fastqc
2- Alinhamento utilizando BWA MEM

Os arquivos intermediários são salvos no diretório intermediate_files, enquanto os arquivos finais são salvos no diretório aligned_files. Ambos diretórios são criados no script. 


O arquivo "gc_deepVariant.sh" contêm os códigos utiliados para a utilização do deepvariant no google cloud. Esta etapa foi iniciada, mas não foi concluída. 


