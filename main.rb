# frozen_string_literal: true

################### Funcoes

###### Gera um individuo aleatorio [0,1,1,0...]
def generate_individuo(n_bits)
  # Nesse caso, bits seria a quantidade de itens
  individuo = []
  n_bits.times do
    bit = rand(0..1)
    individuo.push(bit)
  end
  individuo
end

##### Gera uma populacao aleatioria
def generate_population(n_de_individuos, n_itens)
  populacao = []
  n_de_individuos.times do
    individuo = generate_individuo(n_itens)
    populacao.push(individuo)
  end
  populacao
end

####### Fitnes avaliacao do individuo
# individuo, peso maximo, pesos e valores
def fitness(individuo, peso_maximo, pesos_e_valores)
  peso_total = 0
  valor_total = 0
  # O individuo = [0,1,1,0...]
  # Se 0 o item nao esta na mochila
  # Se 1 quer dizer que esta na mochila

  individuo.each_with_index do |_valor, indice|
    peso_total += (individuo[indice] * pesos_e_valores[indice][0])
    valor_total += (individuo[indice] * pesos_e_valores[indice][1])
  end

  return -1 if (peso_maximo - peso_total) < 0

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
  soma / somados
end

###### Selecao roleta
def selecao_roleta(pais, cromossomos)
  # pais é a lista da populacao com os valores fitnes ordenado
  # popoulacao sao os cromossomos

  # sortea um indice
  def sortear(pais, soma_pais, indice_a_ignorar = -1)
    # fitness_total soma dos valores dos fitness do pai
    roleta = []
    acumulado = 0
    valor_sorteado = rand
    # faz com que nao repita o pai
    if indice_a_ignorar != -1
      soma_pais -= pais[indice_a_ignorar]
    end

    pais.each_with_index do |valor, i|
      if indice_a_ignorar == i # ignora o valor ja utilizado
        next
      end

      acumulado += valor
      roleta.push(acumulado.to_f / soma_pais)
      # Checa a ultima posicao inserida
      if roleta[-1] >= valor_sorteado
        return i
      end
    end
  end

  soma_pais = pais.sum
  indice_pai = sortear(pais, soma_pais)
  indice_mae = sortear(pais, soma_pais, indice_pai)
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
    pais.push(nota)
  end
  # Ordena a lista de forma crescente
  (pais.length - 1).downto(0) do |index|
    if pais[index] < 0
      pais.delete_at(index)
      populacao.delete_at(index)
    end
  end
  pais = pais.sort
  puts("pais: #{pais.length}")
  puts("populacao: #{populacao.length}")
  sorted_indices = pais.each_with_index.sort_by(&:first).map(&:last)
  sorted_pais = pais.sort
  sorted_populacao = sorted_indices.map { |i| populacao[i] }

  ### Reproducao dos pais
  filhos = []
  filhos.concat(populacao.take(30))
  while filhos.length < n_de_individuos
    macho, femea = selecao_roleta(pais, populacao)
    meio = macho.length / 2
    # Aqui eu crio um novo individuo (cromossomo) metade para tras é do pai e para frente é da mae
    filho = macho[0...meio] + femea[0...meio]
    filhos.append(filho)
  end

  ### Mutacao, se nao fazer podemos ficar preso em uma otima solucao sendo que pode ter uma melhor
  filhos.each do |individuo|
    tam_dna = (individuo.length) - 1
    n_sorteado = rand
    # Se 0.05 for maior que numeros de 0 a 1 = 5% de chance, pd passar outro valor
    if mutate > n_sorteado
      # Seleciona uma posicao aleatoria do dna do individuo e muda
      pos_mutate = rand(0..tam_dna)
      if individuo[pos_mutate] == 0
        individuo[pos_mutate] = 1
      else
        individuo[pos_mutate] = 0
      end
    end
  end

  return filhos
  # loop que avalia todos os individuos da populacao > 0
  # Funcao fitness do individuo
  # Organiza a lista

  # Cria lista de filhos
  # loop para reproducao
end

################### codigo
# [peso,valor]
pesos_e_valores = [[4, 30], [8, 10], [8, 30], [25, 75], [2, 10], [50, 100], [6, 300], [12, 50], [100, 400], [8, 300]]
peso_maximo = 100
n_de_individuos = 150
geracoes = 80
n_de_itens = pesos_e_valores.length

populacao = generate_population(n_de_individuos, n_de_itens)
historico_de_fitnes = []
media = media_populacao(populacao, peso_maximo, pesos_e_valores)
historico_de_fitnes.push(media)

geracoes.times do |i|
  populacao = evolve(populacao, peso_maximo, pesos_e_valores, n_de_individuos)
  media = media_populacao(populacao, peso_maximo, pesos_e_valores)
  historico_de_fitnes.push(media)
end

historico_de_fitnes.each_with_index do |dados, indice|
  puts "Geracao: #{indice} | Media valor: #{dados}"
end

puts "\nPeso máximo: #{peso_maximo}g\n\nItens disponíveis:"
pesos_e_valores.each_with_index do |item, indice|
  puts "Item #{indice+1}: #{item[0]}g | R$#{item[1]}"
end

puts "\nExemplos de boas solucoes: "

