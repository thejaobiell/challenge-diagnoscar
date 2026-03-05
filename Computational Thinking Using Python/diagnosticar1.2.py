import re
import json
import requests

def validar_cpf(cpf):
    if not re.match(r"^\d{11}$", cpf):
        return False
    cpf = [int(d) for d in cpf]
    for i in range(9, 11):
        val = sum((cpf[num] * (i + 1 - num) for num in range(0, i)))
        dig = ((val * 10) % 11) % 10
        if dig != cpf[i]:
            return False
    return True

def validar_telefone(telefone):
    return re.match(r"^\d{10,11}$", telefone) is not None

def validar_email(email):
    return re.match(r"^\S+@\S+\.\S+$", email) is not None

def validar_opcao_menu(opcao, max_opcao):
    return opcao.isdigit() and 1 <= int(opcao) <= max_opcao

def entrada_nao_vazia(entrada):
    return entrada.strip() != ""

class Cliente:
    def __init__(self, nome, cpf, cnh, telefone, email, endereco, automoveis):
        self.nome = nome
        self.cpf = cpf
        self.cnh = cnh
        self.telefone = telefone
        self.email = email
        self.endereco = endereco
        self.automoveis = automoveis

class Diagnostico:
    def __init__(self, cpf, relato, problemas):
        self.cpf = cpf
        self.relato = relato
        self.problemas = problemas

def prever_problemas_futuros(diagnosticos):
    print("===============================================================")
    print("Previsão de Problemas Futuros")
    frequencia_problemas = {}

    for diagnostico in diagnosticos:
        for problema in diagnostico.problemas:
            frequencia_problemas[problema] = frequencia_problemas.get(problema, 0) + 1

    problemas_mais_frequentes = sorted(frequencia_problemas.items(), key=lambda x: x[1], reverse=True)

    if problemas_mais_frequentes:
        print("Problemas mais frequentes e suas contagens:")
        for problema, contagem in problemas_mais_frequentes:
            print(f"- {problema}: {contagem} vezes")
    else:
        print("Não há dados suficientes para prever problemas futuros.")

    print("\nSugestões de ações preventivas baseadas nos problemas mais frequentes:")
    for problema, _ in problemas_mais_frequentes:
        print(f"- Verificar e realizar manutenção preventiva no sistema de {problema}.")

def cadastrar_cliente(cad_cliente):
    try:
        nome = input("Digite o nome: ")
        while not entrada_nao_vazia(nome):
            print("Nome não pode estar vazio. Por favor, insira um nome válido.")
            nome = input("Digite o nome: ")

        cpf = input("Digite o CPF (somente números): ")
        while not validar_cpf(cpf):
            print("CPF inválido. Deve conter 11 dígitos numéricos e ser válido.")
            cpf = input("Digite o CPF novamente: ")

        cnh = input("Digite a CNH: ")
        while not entrada_nao_vazia(cnh):
            print("CNH não pode estar vazia. Por favor, insira a CNH.")
            cnh = input("Digite a CNH novamente: ")

        telefone = input("Digite o telefone (com DDD, somente números): ")
        while not validar_telefone(telefone):
            print("Telefone inválido. Deve conter 10 ou 11 dígitos numéricos.")
            telefone = input("Digite o telefone novamente: ")

        email = input("Digite o email: ")
        while not validar_email(email):
            print("Email inválido. Formato esperado: exemplo@dominio.com")
            email = input("Digite o email novamente: ")

        endereco = input("Digite o endereço: ")
        while not entrada_nao_vazia(endereco):
            print("Endereço não pode estar vazio. Por favor, insira um endereço válido.")
            endereco = input("Digite o endereço novamente: ")

        automoveis = input(
            "Digite os modelos dos automóveis (separados por vírgula): "
        ).split(",")
        while not automoveis or any(not entrada_nao_vazia(carro) for carro in automoveis):
            print("Modelos dos automóveis não podem estar vazios.")
            automoveis = input(
                "Digite os modelos dos automóveis novamente (separados por vírgula): "
            ).split(",")

        cliente = Cliente(nome, cpf, cnh, telefone, email, endereco, automoveis)
        cad_cliente[cpf] = cliente
        print("===============================================================")
        print(f"Conta criada com sucesso para o cliente {nome}.")
    except Exception as e:
        print(f"Ocorreu um erro ao cadastrar o cliente: {e}")

def alterar_cliente(cad_cliente):
    try:
        cpf = input("Digite o CPF do cliente a ser alterado: ")
        if cpf in cad_cliente:
            cliente = cad_cliente[cpf]
            print(f"Alterando dados do cliente {cliente.nome}:")
            cliente.nome = input(f"Nome [{cliente.nome}]: ") or cliente.nome
            cliente.cnh = input(f"CNH [{cliente.cnh}]: ") or cliente.cnh
            cliente.telefone = input(f"Telefone [{cliente.telefone}]: ") or cliente.telefone
            cliente.email = input(f"Email [{cliente.email}]: ") or cliente.email
            cliente.endereco = input(f"Endereço [{cliente.endereco}]: ") or cliente.endereco
            cliente.automoveis = (
                input(f"Automóveis [{', '.join(cliente.automoveis)}]: ").split(",")
                or cliente.automoveis
            )
            print("Dados do cliente atualizados com sucesso!")
        else:
            print("Cliente não encontrado.")
    except Exception as e:
        print(f"Erro ao alterar cliente: {e}")

def excluir_cliente(cad_cliente):
    try:
        cpf = input("Digite o CPF do cliente a ser excluído: ")
        if cpf in cad_cliente:
            del cad_cliente[cpf]
            print("Cliente excluído com sucesso!")
        else:
            print("Cliente não encontrado.")
    except Exception as e:
        print(f"Erro ao excluir cliente: {e}")

def exportar_clientes_json(cad_cliente):
    try:
        with open("clientes.json", "w") as file:
            json.dump({cpf: cliente.__dict__ for cpf, cliente in cad_cliente.items()}, file, indent=4)
        print("Clientes exportados com sucesso para 'clientes.json'.")
    except Exception as e:
        print(f"Erro ao exportar clientes: {e}")

def iniciar_diagnostico(cad_cliente, diagnosticos, problems_chaves):
    try:
        cpf = input("Digite o CPF do cliente para começar o diagnóstico: ")
        while not validar_cpf(cpf):
            print("CPF inválido. Deve conter 11 dígitos numéricos.")
            cpf = input("Digite o CPF novamente: ")

        if cpf in cad_cliente:
            cliente = cad_cliente[cpf]
            print("===============================================================")
            print("Diagnóstico iniciado. Escolha o carro com problema:")
            for i, carro in enumerate(cliente.automoveis, 1):
                print(f"{i} - {carro}")

            carro_selecionado = input(
                "Digite o número correspondente ao carro com problema: "
            )
            while not carro_selecionado.isdigit() or not (
                1 <= int(carro_selecionado) <= len(cliente.automoveis)
            ):
                print("Opção inválida. Digite um número válido correspondente ao carro.")
                carro_selecionado = input(
                    "Digite o número correspondente ao carro com problema: "
                )

            carro_selecionado = int(carro_selecionado)
            relato = input("Por favor, conte-me sobre o problema: ")
            problemas_encontrados = []

            for problema, palavras_chave in problems_chaves.items():
                for palavra_chave in palavras_chave:
                    if palavra_chave in relato:
                        problemas_encontrados.append(problema)
                        break

            if problemas_encontrados:
                print("===============================================================")
                print("Problemas identificados:")
                for problema in problemas_encontrados:
                    print("-", problema)
                diagnostico = Diagnostico(cpf, relato, problemas_encontrados)
                diagnosticos.append(diagnostico)
            else:
                print("===============================================================")
                print("Não conseguimos identificar o problema. Ligue para Porto Seguro para melhor pré-diagnóstico.")
        else:
            print("===============================================================")
            print("Cliente não encontrado.")
    except Exception as e:
        print(f"Erro ao iniciar diagnóstico: {e}")

def encaminhar_oficina(cad_cliente):
    try:
        cpf = input("Digite o CPF do cliente para encaminhar à oficina: ")
        while not validar_cpf(cpf):
            print("CPF inválido. Deve conter 11 dígitos numéricos.")
            cpf = input("Digite o CPF novamente: ")

        if cpf in cad_cliente:
            print("===============================================================")
            print("Cliente encaminhado para a oficina.")
        else:
            print("===============================================================")
            print("Cliente não encontrado.")
    except Exception as e:
        print(f"Erro ao encaminhar cliente: {e}")

def visualizar_clientes_cadastrados(cad_cliente):
    if cad_cliente:
        print("===============================================================")
        print("Clientes cadastrados:")
        for cliente in cad_cliente.values():
            print("CPF:", cliente.cpf)
            print("Nome:", cliente.nome)
            print("Endereço:", cliente.endereco)
            print("-------------------")
    else:
        print("===============================================================")
        print("Não há clientes cadastrados.")

def visualizar_diagnosticos_realizados(diagnosticos):
    if diagnosticos:
        print("===============================================================")
        print("Diagnósticos realizados:")
        for diagnostico in diagnosticos:
            print("CPF:", diagnostico.cpf)
            print("Relato do problema:", diagnostico.relato)
            print("Problemas identificados:")
            for problema in diagnostico.problemas:
                print("-", problema)
            print("-------------------")
    else:
        print("===============================================================")
        print("Não há diagnósticos realizados.")

def consultar_api_externa():
    url = "https://api-validador-cpf.vercel.app/"  # API
    cpf = input("Digite o CPF para validação externa: ")
    headers = {
        "apikey": "SUA_CHAVE_API_AQUI"
    }
    try:
        response = requests.get(f"{url}?cpf={cpf}", headers=headers)
        if response.status_code == 200:
            resultado = response.json()
            if resultado["valido"]:
                print("CPF validado com sucesso!")
            else:
                print("CPF inválido.")
        else:
            print("Erro ao conectar com a API.")
    except requests.RequestException as e:
        print(f"Erro ao consultar API externa: {e}")

def menu():
    cad_cliente = {}
    diagnosticos = []
    
    problems_chaves = {
        "bateria": [
            "não liga", "nao liga", "morreu", "descarregada", "luzes piscando", 
            "conexão frouxa", "problema elétrico", "falha elétrica", "luzes fracas"
        ],
        "pneu": [
            "furado", "vazio", "baixa pressão", "desgaste irregular", "vibração", 
            "barulho", "furo", "calibragem incorreta", "aderência reduzida"
        ],
        "motor": [
            "barulho", "ruído", "vibração", "superaquecimento", "motor morrendo", 
            "perda de potência", "consumo elevado", "fumaça", "vazamento de óleo"
        ],
        "freios": [
            "barulho ao frear", "freio duro", "freio mole", "pedal vibrando", 
            "freio falhando", "falta de fluido", "disco empenado", "freio puxando"
        ],
        "sistema de arrefecimento": [
            "motor superaquecendo", "vazamento de água", "vazamento de fluido", 
            "radiador quebrado", "ventoinha não liga", "ventoinha nao liga", 
            "aquecimento excessivo", "fuga de água", "mangueira rompida"
        ],
        "suspensão": [
            "barulho na suspensão", "carro balançando", "amortecedor quebrado", 
            "molas soltas", "batidas secas", "desalinhamento", "suspensão dura", 
            "suspensão mole", "estalos ao virar"
        ],
        "transmissão": [
            "câmbio duro", "embreagem escorregando", "dificuldade de engatar marcha", 
            "ruído no câmbio", "vazamento de óleo de transmissão", 
            "embreagem trepidando", "troca de marcha falhando", "câmbio quebrado"
        ],
        "direção": [
            "volante vibrando", "direção pesada", "vazamento de fluido de direção", 
            "direção desalinhada", "folga no volante", "dificuldade ao virar", 
            "barulho ao esterçar", "direção falhando"
        ],
        "escapamento": [
            "ruído no escapamento", "barulho alto no escapamento", 
            "vazamento no escapamento", "silenciador quebrado", 
            "fumaça escura", "cheiro de combustível", "cheiro de gás", 
            "escapamento furado"
        ],
        "sistema elétrico": [
            "falha no alternador", "luzes não acendem", "buzina não funciona", 
            "fusível queimado", "falha na fiação", "cheiro de queimado", 
            "curto-circuito", "farol não funciona", "seta não funciona"
        ]
    }


    while True:
        print("===============================================================")
        print("Bem-vindo ao DiagnostiCar!")
        print("Escolha uma opção:")
        print("1 - Criar conta")
        print("2 - Alterar conta")
        print("3 - Excluir conta")
        print("4 - Iniciar diagnóstico")
        print("5 - Encaminhar para oficina")
        print("6 - Visualizar clientes cadastrados")
        print("7 - Visualizar diagnósticos realizados")
        print("8 - Prever problemas futuros")
        print("9 - Exportar clientes para JSON")
        print("10 - Consultar API externa")
        print("11 - Sair")
        opcao = input("Opção: ")

        if validar_opcao_menu(opcao, 11):
            opcao = int(opcao)
            if opcao == 1:
                cadastrar_cliente(cad_cliente)
            elif opcao == 2:
                alterar_cliente(cad_cliente)
            elif opcao == 3:
                excluir_cliente(cad_cliente)
            elif opcao == 4:
                iniciar_diagnostico(cad_cliente, diagnosticos, problems_chaves)
            elif opcao == 5:
                encaminhar_oficina(cad_cliente)
            elif opcao == 6:
                visualizar_clientes_cadastrados(cad_cliente)
            elif opcao == 7:
                visualizar_diagnosticos_realizados(diagnosticos)
            elif opcao == 8:
                prever_problemas_futuros(diagnosticos)
            elif opcao == 9:
                exportar_clientes_json(cad_cliente)
            elif opcao == 10:
                consultar_api_externa()
            elif opcao == 11:
                print("Saindo do sistema...")
                break
        else:
            print("===============================================================")
            print("Opção inválida. Tente novamente.")

menu()
