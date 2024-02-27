################### Funcoes

###### Gera um individuo aleatorio [0,1,1,0...]
def generate_individuo(n_bits)
  # Nesse caso, bits seria a quantidade de itens
  individuo = []
  n_bits.times do
    bit = rand(0..1)
    individuo.push(bit)  
  end
  return individuo
end


##### Gera uma populacao aleatioria
def generate_population(n_de_individuos, n_itens)
  populacao = []
  n_de_individuos.times do
    individuo = generate_individuo(n_itens)
    populacao.push(individuo)
  end
  return populacao
end

####### Fitnes avaliacao do individuo
# individuo, peso maximo, pesos e valores
def fitness(individuo, peso_maximo, pesos_e_valores)
  peso_total, valor_total = 0, 0
  # O individuo = [0,1,1,0...]
  # Se 0 o item nao esta na mochila
  # Se 1 quer dizer que esta na mochila

  individuo.each_with_index do |valor, indice|
    peso_total += (individuo[indice] * pesos_e_valores[indice][0])
    valor_total += (individuo[indice] * pesos_e_valores[indice][1])
  end

  if (peso_maximo - peso_total) < 0 
    return -1
  end
  return valor_total
end


###### Funcao media da populacao
def media_populacao(populacao, peso_maximo, pesos_e_valores)
  soma = 0
  somados = 0.0
  populacao.each do |individuo|
    nota = fitness(individuo, peso_maximo, pesos_e_valores)
    if nota > 0 
      soma += nota
    somados += 1.0
    end
  end
  return soma / somados
end




###### Selecao roleta
def selecao_roleta(pais, cromossomos) 
  # pais é a lista da populacao com os valores fitnes ordenado 
  # popoulacao sao os cromossomos

  # Sortea um indice  
  def sortear(soma_pais, indice_a_ignorar=-1)
    # fitness_total soma dos valores dos fitness do pai
    roleta, acumulado, valor_sorteado = [], 0, random()
   
    # Faz com que nao repita o pai
    if indice_a_ignorar != -1 
      soma_pais -= pais[indice_a_ignorar]
   
    pais.each_with_index do |valor, i|
      if indice_a_ignorar == indice
  end

  soma_pais = pais.sum

  indice_pai = sortear(soma_pais)
  indice_mae = sortear(soma_pais, indice_a_ignorar=indice_pai)
  
  pai = cromossomos[indice_pai]
  mae = cromossomos[indice_mae]

  return pai, mae
end




####### Evolve funcao principal
def evolve(populacao, peso_maximo, pesos_e_valores, n_de_individuos, mutate = 0.05) 

  # Avaliacao de cada um dos individuos da populacao e cria uma nova lista com apenas os
  # Individuos com valor > 0
  # Apaga os valores indesejados da populacao dos cromossomos
  pais = []
  populacao.each_with_index do |individuo, index|
    nota = fitness(individuo, peso_maximo, pesos_e_valores)
    if nota > 0
      pais.push(nota)
    else
      populacao.delete_at(index)
    end
  end 
  # Ordena a lista de forma crescente
  pais = pais.sort

  ### Reproducao dos pais
  filhos = []
  while (filhos.length) < n_de_individuos do
    macho, femea = selecao_roleta(pais, populacao)
  end

  # loop que avalia todos os individuos da populacao > 0
  # Funcao fitness do individuo
  # Organiza a lista 

  # Cria lista de filhos
  # loop para reproducao

end

################### codigo
#[peso,valor]
pesos_e_valores = [[4, 30], [8, 10], [8, 30], [25, 75], [2, 10], [50, 100], [6, 300], [12, 50], [100, 400], [8, 300]]
peso_maximo = 100
n_de_individuos = 150
geracoes = 80
n_de_itens = pesos_e_valores.length

# Gera populacao aleatoria com a funcao         > population
populacao = generate_population(n_de_individuos, n_de_itens)
# Media da populacao e adiciona ao historico    > mediaFitnes
historico_de_fitnes = []
media = media_populacao(populacao, peso_maximo, pesos_e_valores)
historico_de_fitnes.push(media)
print(media)
# Loop que roda em geracoes                     > Loop 
evolve(populacao, peso_maximo, pesos_e_valores, n_de_individuos)
# gera uma nova populacao                       > evolve
# Media da populacao/geracao e armazena         > media fitnes
#
# Prints terminal 
#


