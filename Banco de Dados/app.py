from flask import Flask, request, redirect
import mysql.connector
from html import escape
from urllib.parse import quote

import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

def conectar_banco():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME")
    )

def pagina(conteudo):
    estilos = """
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 40px 24px;
            font-family: Arial, sans-serif;
            background: #f0f5ff;
            color: #243552;
            line-height: 1.6;
        }

        .container {
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
        }

        h1, h2 {
            color: #173f80;
        }

        h1 {
            font-size: 32px;
        }

        h2 {
            margin-top: 36px;
        }

        h3 {
            margin-top: 0;
            color: #2457a7;
        }

        a {
            color: #2457a7;
            font-weight: 600;
            text-decoration: none;
        }

        a:hover {
            color: #12376f;
            text-decoration: underline;
        }

        form {
            max-width: 650px;
            margin: 24px auto;
            padding: 28px;
            background: white;
            border: 1px solid #dce7f8;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(36, 87, 167, 0.07);
        }

        label {
            display: block;
            margin: 10px 0 5px;
            font-weight: 600;
        }

        input, select, textarea {
            width: 100%;
            padding: 12px 14px;
            margin: 6px 0 16px;
            border: 1px solid #c8d7ee;
            border-radius: 9px;
            background: #fbfdff;
            color: #243552;
            font: inherit;
        }

        textarea {
            min-height: 110px;
        }

        button {
            padding: 11px 20px;
            border: none;
            border-radius: 9px;
            background: #2457a7;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            background: #173f80;
        }

        table {
            width: 100%;
            margin: 24px 0;
            border-collapse: collapse;
            background: white;
            border: 1px solid #dce7f8;
        }

        th {
            background: #2457a7;
            color: white;
        }

        th, td {
            padding: 14px 16px;
            border-bottom: 1px solid #e5edf9;
            text-align: left;
        }

        tr:nth-child(even) {
            background: #f7faff;
        }

        .mensagem {
            padding: 13px 16px;
            border-radius: 10px;
            background: #e5efff;
            color: #173f80;
            font-weight: 600;
        }

        .cabecalho {
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 30px;
            background: white;
            border: 1px solid #dce7f8;
            border-radius: 18px;
            box-shadow: 0 8px 24px rgba(36, 87, 167, 0.07);
        }

        .cabecalho h1 {
            margin: 0;
        }

        .cabecalho p {
            margin: 4px 0 0;
            color: #61728b;
        }

        .marca {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 64px;
            height: 64px;
            flex-shrink: 0;
            border-radius: 17px;
            background: #2457a7;
            color: white;
            font-size: 32px;
            font-weight: bold;
        }

        .grade-menu {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 24px;
            margin: 28px 0;
        }

        .cartao-menu {
            padding: 26px;
            background: white;
            border: 1px solid #dce7f8;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(36, 87, 167, 0.06);
        }

        .cartao-menu p {
            color: #61728b;
        }

        .cartao-menu a {
            display: block;
            padding: 11px 0;
            border-bottom: 1px solid #edf2fa;
        }

        .cartao-menu a:last-child {
            border-bottom: none;
        }

        @media (max-width: 700px) {
            body {
                padding: 20px 14px;
            }

            .grade-menu {
                grid-template-columns: 1fr;
            }

            .cabecalho {
                padding: 20px;
            }

            table {
                display: block;
                overflow-x: auto;
            }
        }
    """

    return f"""
    <!DOCTYPE html>
    <html lang="pt-br">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Destrava</title>
        <style>{estilos}</style>
    </head>
    <body>
        <main class="container">
            {conteudo}
        </main>
    </body>
    </html>
    """
@app.route("/")
def inicio():
    return pagina("""
        <header class="cabecalho">
            <span class="marca">D</span>
            <div>
                <h1>Destrava</h1>
                <p>Aprenda informática no seu ritmo!</p>
            </div>
        </header>

        <h2>Bem-vindo ao Destrava!</h2>
        <p>O que você deseja acessar hoje?</p>

        <div class="grade-menu">
            <section class="cartao-menu">
                <h3>Cadastros</h3>
                <p>Gerencie as informações do sistema.</p>
                <a href="/alunos">Gerenciar alunos →</a>
                <a href="/trilhas">Gerenciar trilhas →</a>
                <a href="/aulas">Gerenciar aulas →</a>
                <a href="/conquistas">Gerenciar conquistas →</a>
            </section>

            <section class="cartao-menu">
                <h3>Consultas</h3>
                <p>Consulte informações sobre as aulas.</p>
                <a href="/consultas/aulas">Aulas por status →</a>
                <a href="/consultas/trilhas">Aulas por trilha →</a>
            </section>

            <section class="cartao-menu">
                <h3>Relatórios</h3>
                <p>Visualize os dados reunidos do sistema.</p>
                <a href="/relatorio">Relatório consolidado de aulas →</a>
            </section>

            <section class="cartao-menu">
                <h3>Banco de dados</h3>
                <p>Verifique a conexão com o MySQL.</p>
                <a href="/teste-banco">Testar conexão →</a>
            </section>
        </div>
    """)

@app.route("/alunos", methods=["GET", "POST"])
def alunos():
    mensagem = request.args.get("mensagem", "")
    conexao = None
    cursor = None

    try:
        if request.method == "POST":
            nome = request.form.get("primeiro_nome", "").strip()
            sobrenome = request.form.get("sobrenome", "").strip()
            email = request.form.get("email", "").strip()
            senha = request.form.get("senha", "")
            nascimento = request.form.get("nascimento", "")

            if not all([nome, sobrenome, email, senha, nascimento]):
                mensagem = "Preencha todos os campos."
            else:
                conexao = conectar_banco()
                cursor = conexao.cursor()
                conexao.start_transaction()

                cursor.execute("""
                    INSERT INTO usuario
                    (primeiro_nome, sobrenome, email, senha, tipo_perfil)
                    VALUES (%s, %s, %s, %s, 'ALUNO')
                """, (nome, sobrenome, email, senha))

                id_usuario = cursor.lastrowid

                cursor.execute("""
                    INSERT INTO aluno (id_usuario, dt_nascimento)
                    VALUES (%s, %s)
                """, (id_usuario, nascimento))

                conexao.commit()
                return redirect("/alunos?mensagem=" +
                                quote("Aluno cadastrado com sucesso!"))

        if conexao is None:
            conexao = conectar_banco()
        if cursor is None:
            cursor = conexao.cursor(dictionary=True)
        else:
            cursor.close()
            cursor = conexao.cursor(dictionary=True)

        cursor.execute("""
            SELECT u.id_usuario, u.primeiro_nome, u.sobrenome,
                   u.email, a.dt_nascimento
            FROM usuario u
            INNER JOIN aluno a ON u.id_usuario = a.id_usuario
            ORDER BY u.id_usuario
        """)
        registros = cursor.fetchall()

    except mysql.connector.Error as erro:
        if conexao and conexao.is_connected():
            conexao.rollback()
        if getattr(erro, "errno", None) == 1062:
            mensagem = "Esse e-mail já está cadastrado."
        else:
            mensagem = "Não foi possível concluir a operação. Confira os dados."

        registros = []
        if request.method == "GET":
            return pagina(f"""
                <h1>Alunos</h1>
                <p>{escape(mensagem)}</p>
                <p><a href="/alunos">Voltar</a></p>
            """), 500

    finally:
        if cursor:
            cursor.close()
        if conexao and conexao.is_connected():
            conexao.close()

    linhas = ""
    for aluno in registros:
        identificador = int(aluno["id_usuario"])
        nome_completo = escape(
            str(aluno["primeiro_nome"]) + " " + str(aluno["sobrenome"])
        )
        email = escape(str(aluno["email"]))
        nascimento = escape(str(aluno["dt_nascimento"]))

        linhas += f"""
            <tr>
                <td>{nome_completo}</td>
                <td>{email}</td>
                <td>{nascimento}</td>
                <td>
                    <a href="/alunos/editar/{identificador}">Editar</a>
                    <form method="POST"
                          action="/alunos/excluir/{identificador}"
                          onsubmit="return confirm('Deseja excluir este aluno?')"
                          style="display:inline;padding:0;margin:0">
                        <button type="submit">Excluir</button>
                    </form>
                </td>
            </tr>
        """

    return pagina(f"""
        <p><a href="/">Voltar ao menu</a></p>
        <h1>Cadastro de alunos</h1>
        <p class="mensagem">{escape(mensagem)}</p>

        <form method="POST">
            <h2>Novo aluno</h2>
            <label>Primeiro nome:</label><br>
            <input name="primeiro_nome" required><br>

            <label>Sobrenome:</label><br>
            <input name="sobrenome" required><br>

            <label>E-mail:</label><br>
            <input type="email" name="email" required><br>

            <label>Senha:</label><br>
            <input type="password" name="senha" required><br>

            <label>Data de nascimento:</label><br>
            <input type="date" name="nascimento" required><br>

            <button type="submit">Cadastrar aluno</button>
        </form>

        <h2>Alunos cadastrados</h2>
        <table border="1">
            <tr>
                <th>Nome</th><th>E-mail</th>
                <th>Nascimento</th><th>Ações</th>
            </tr>
            {linhas}
        </table>
    """)

@app.route("/alunos/editar/<int:id_aluno>", methods=["GET", "POST"])
def editar_aluno(id_aluno):
    conexao = None
    cursor = None

    try:
        conexao = conectar_banco()
        cursor = conexao.cursor(dictionary=True)

        if request.method == "POST":
            nome = request.form.get("primeiro_nome", "").strip()
            sobrenome = request.form.get("sobrenome", "").strip()
            email = request.form.get("email", "").strip()
            nascimento = request.form.get("nascimento", "")

            if not all([nome, sobrenome, email, nascimento]):
                return pagina("""
                    <h1>Preencha todos os campos.</h1>
                    <a href="/alunos">Voltar</a>
                """), 400

            conexao.start_transaction()

            cursor.execute("""
                UPDATE usuario
                SET primeiro_nome=%s, sobrenome=%s, email=%s
                WHERE id_usuario=%s AND tipo_perfil='ALUNO'
            """, (nome, sobrenome, email, id_aluno))

            cursor.execute("""
                UPDATE aluno
                SET dt_nascimento=%s
                WHERE id_usuario=%s
            """, (nascimento, id_aluno))

            if cursor.rowcount == 0:
                cursor.execute("""
                    SELECT id_usuario FROM aluno WHERE id_usuario=%s
                """, (id_aluno,))
                if not cursor.fetchone():
                    conexao.rollback()
                    return pagina("""
                        <h1>Aluno não encontrado.</h1>
                        <a href="/alunos">Voltar</a>
                    """), 404

            conexao.commit()
            return redirect("/alunos?mensagem=" +
                            quote("Aluno atualizado com sucesso!"))

        cursor.execute("""
            SELECT u.primeiro_nome, u.sobrenome, u.email, a.dt_nascimento
            FROM usuario u
            INNER JOIN aluno a ON u.id_usuario=a.id_usuario
            WHERE u.id_usuario=%s AND u.tipo_perfil='ALUNO'
        """, (id_aluno,))
        aluno = cursor.fetchone()

        if not aluno:
            return pagina("""
                <h1>Aluno não encontrado.</h1>
                <a href="/alunos">Voltar</a>
            """), 404

        return pagina(f"""
            <h1>Editar aluno</h1>
            <form method="POST">
                <label>Primeiro nome:</label><br>
                <input name="primeiro_nome"
                       value="{escape(aluno['primeiro_nome'])}" required><br>

                <label>Sobrenome:</label><br>
                <input name="sobrenome"
                       value="{escape(aluno['sobrenome'])}" required><br>

                <label>E-mail:</label><br>
                <input type="email" name="email"
                       value="{escape(aluno['email'])}" required><br>

                <label>Data de nascimento:</label><br>
                <input type="date" name="nascimento"
                       value="{aluno['dt_nascimento']}" required><br>

                <button type="submit">Salvar alterações</button>
            </form>
            <p><a href="/alunos">Cancelar</a></p>
        """)

    except mysql.connector.Error as erro:
        if conexao and conexao.is_connected():
            conexao.rollback()
        if getattr(erro, "errno", None) == 1062:
            mensagem = "Esse e-mail já está cadastrado."
        else:
            mensagem = "Não foi possível editar o aluno."
        return pagina(f"""
            <h1>{escape(mensagem)}</h1>
            <a href="/alunos">Voltar</a>
        """), 400

    finally:
        if cursor:
            cursor.close()
        if conexao and conexao.is_connected():
            conexao.close()

@app.route("/alunos/excluir/<int:id_aluno>", methods=["POST"])
def excluir_aluno(id_aluno):
    conexao = None
    cursor = None

    try:
        conexao = conectar_banco()
        cursor = conexao.cursor()
        cursor.execute("""
            DELETE FROM usuario
            WHERE id_usuario=%s AND tipo_perfil='ALUNO'
        """, (id_aluno,))
        conexao.commit()

        if cursor.rowcount == 0:
            mensagem = "Aluno não encontrado."
        else:
            mensagem = "Aluno excluído com sucesso!"

        return redirect("/alunos?mensagem=" + quote(mensagem))

    except mysql.connector.Error:
        if conexao and conexao.is_connected():
            conexao.rollback()
        return pagina("""
            <h1>Não foi possível excluir o aluno.</h1>
            <a href="/alunos">Voltar</a>
        """), 400

    finally:
        if cursor:
            cursor.close()
        if conexao and conexao.is_connected():
            conexao.close()

@app.route("/teste-banco")
def teste_banco():
    conexao = None
    cursor = None

    try:
        conexao = conectar_banco()
        cursor = conexao.cursor()
        cursor.execute("SHOW TABLES")
        tabelas = cursor.fetchall()
        lista = "".join(
            f"<li>{escape(str(tabela[0]))}</li>" for tabela in tabelas
        )
        return pagina(f"""
            <h1>Conexão realizada!</h1>
            <p>Tabelas encontradas:</p>
            <ul>{lista}</ul>
            <a href="/">Voltar ao menu</a>
        """)

    except mysql.connector.Error:
        return pagina("""
            <h1>Erro na conexão</h1>
            <p>Confira o MySQL e a configuração do app.py.</p>
        """), 500

    finally:
        if cursor:
            cursor.close()
        if conexao and conexao.is_connected():
            conexao.close()

@app.route("/trilhas", methods=["GET", "POST"])
def trilhas():
    mensagem = request.args.get("mensagem", "")
    conexao = None
    cursor = None

    try:
        conexao = conectar_banco()
        cursor = conexao.cursor(dictionary=True)

        if request.method == "POST":
            acao = request.form.get("acao", "")
            nome = request.form.get("nome", "").strip()
            descricao = request.form.get("descricao", "").strip()
            idade_min = request.form.get("faixa_etaria_min", "")
            idade_max = request.form.get("faixa_etaria_max", "")
            id_trilha = request.form.get("id_trilha", "")

            if acao in ("cadastrar", "editar"):
                if not nome or not idade_min or not idade_max:
                    mensagem = "Preencha o nome e as duas faixas etárias."
                else:
                    idade_min = int(idade_min)
                    idade_max = int(idade_max)

                    if idade_min < 0 or idade_max < idade_min:
                        mensagem = "Confira as faixas etárias informadas."
                    else:
                        if acao == "cadastrar":
                            cursor.execute("""
                                INSERT INTO trilha
                                (nome, descricao, faixa_etaria_min,
                                 faixa_etaria_max)
                                VALUES (%s, %s, %s, %s)
                            """, (nome, descricao or None,
                                  idade_min, idade_max))
                            mensagem = "Trilha cadastrada com sucesso!"
                        else:
                            cursor.execute("""
                                UPDATE trilha
                                SET nome=%s, descricao=%s,
                                    faixa_etaria_min=%s,
                                    faixa_etaria_max=%s
                                WHERE id_trilha=%s
                            """, (nome, descricao or None,
                                  idade_min, idade_max, id_trilha))
                            mensagem = "Trilha atualizada com sucesso!"

                        conexao.commit()

            elif acao == "excluir":
                cursor.execute(
                    "DELETE FROM trilha WHERE id_trilha=%s",
                    (id_trilha,)
                )
                conexao.commit()
                mensagem = "Trilha excluída com sucesso!"

        cursor.execute("SELECT * FROM trilha ORDER BY id_trilha")
        registros = cursor.fetchall()

    except (mysql.connector.Error, ValueError):
        if conexao and conexao.is_connected():
            conexao.rollback()
        mensagem = "Não foi possível concluir. Confira os dados e tente novamente."
        registros = []

    finally:
        if cursor:
            cursor.close()
        if conexao and conexao.is_connected():
            conexao.close()

    linhas = ""
    for trilha in registros:
        identificador = int(trilha["id_trilha"])
        nome = escape(str(trilha["nome"]))
        descricao = escape(str(trilha["descricao"] or ""))
        idade_min = int(trilha["faixa_etaria_min"])
        idade_max = int(trilha["faixa_etaria_max"])

        linhas += f"""
        <tr>
            <td>{identificador}</td>
            <td>{nome}</td>
            <td>{descricao}</td>
            <td>{idade_min} a {idade_max} anos</td>
            <td>
                <details>
                    <summary>Editar</summary>
                    <form method="POST">
                        <input type="hidden" name="acao" value="editar">
                        <input type="hidden" name="id_trilha"
                               value="{identificador}">
                        <label>Nome:</label><br>
                        <input name="nome" value="{nome}" required><br>
                        <label>Descrição:</label><br>
                        <input name="descricao" value="{descricao}"><br>
                        <label>Idade mínima:</label><br>
                        <input type="number" name="faixa_etaria_min"
                               value="{idade_min}" min="0" required><br>
                        <label>Idade máxima:</label><br>
                        <input type="number" name="faixa_etaria_max"
                               value="{idade_max}" min="0" required><br>
                        <button type="submit">Salvar</button>
                    </form>
                </details>
                <form method="POST"
                      onsubmit="return confirm('Excluir esta trilha?')">
                    <input type="hidden" name="acao" value="excluir">
                    <input type="hidden" name="id_trilha"
                           value="{identificador}">
                    <button type="submit">Excluir</button>
                </form>
            </td>
        </tr>
        """

    return pagina(f"""
        <p><a href="/">Voltar ao menu</a></p>
        <h1>Gerenciar trilhas</h1>
        <p class="mensagem">{escape(mensagem)}</p>

        <form method="POST">
            <h2>Cadastrar trilha</h2>
            <input type="hidden" name="acao" value="cadastrar">
            <label>Nome:</label><br>
            <input name="nome" required><br>
            <label>Descrição:</label><br>
            <input name="descricao"><br>
            <label>Idade mínima:</label><br>
            <input type="number" name="faixa_etaria_min"
                   min="0" required><br>
            <label>Idade máxima:</label><br>
            <input type="number" name="faixa_etaria_max"
                   min="0" required><br>
            <button type="submit">Cadastrar trilha</button>
        </form>

        <h2>Trilhas cadastradas</h2>
        <table border="1">
            <tr>
                <th>ID</th><th>Nome</th><th>Descrição</th>
                <th>Faixa etária</th><th>Ações</th>
            </tr>
            {linhas}
        </table>
    """)


@app.route("/trilhas/editar")
def trilhas_editar_redirecionamento():
    return redirect("/trilhas")


@app.route("/aulas", methods=["GET", "POST"])
def aulas():
    mensagem = request.args.get("mensagem", "")
    conexao = None
    cursor = None
    registros = []
    trilhas = []
    niveis = []

    try:
        conexao = conectar_banco()
        cursor = conexao.cursor(dictionary=True)

        if request.method == "POST":
            acao = request.form.get("acao", "")
            titulo = request.form.get("titulo", "").strip()
            conteudo = request.form.get("conteudo", "").strip()
            status = request.form.get("status", "")
            id_trilha = request.form.get("id_trilha", "")
            id_nivel = request.form.get("id_nivel", "")
            id_aula = request.form.get("id_aula", "")

            if acao in ("cadastrar", "editar"):
                if not all([titulo, conteudo, status, id_trilha, id_nivel]):
                    mensagem = "Preencha todos os campos."
                elif status not in (
                    "NAO_INICIADA", "EM_ANDAMENTO", "CONCLUIDA"
                ):
                    mensagem = "Status inválido."
                else:
                    if acao == "cadastrar":
                        cursor.execute("""
                            INSERT INTO aula
                            (titulo, conteudo, status, id_trilha, id_nivel)
                            VALUES (%s, %s, %s, %s, %s)
                        """, (titulo, conteudo, status,
                              id_trilha, id_nivel))
                        mensagem = "Aula cadastrada com sucesso!"
                    else:
                        cursor.execute("""
                            UPDATE aula
                            SET titulo=%s, conteudo=%s, status=%s,
                                id_trilha=%s, id_nivel=%s
                            WHERE id_aula=%s
                        """, (titulo, conteudo, status,
                              id_trilha, id_nivel, id_aula))
                        mensagem = "Aula atualizada com sucesso!"

                    conexao.commit()

            elif acao == "excluir":
                cursor.execute(
                    "DELETE FROM aula WHERE id_aula=%s",
                    (id_aula,)
                )
                conexao.commit()
                mensagem = "Aula excluída com sucesso!"

        cursor.execute("SELECT id_trilha, nome FROM trilha ORDER BY nome")
        trilhas = cursor.fetchall()

        cursor.execute("SELECT id_nivel, nome FROM nivel ORDER BY ordem")
        niveis = cursor.fetchall()

        cursor.execute("""
            SELECT a.id_aula, a.titulo, a.conteudo, a.status,
                   a.id_trilha, a.id_nivel,
                   t.nome AS nome_trilha, n.nome AS nome_nivel
            FROM aula a
            INNER JOIN trilha t ON a.id_trilha = t.id_trilha
            INNER JOIN nivel n ON a.id_nivel = n.id_nivel
            ORDER BY a.id_aula
        """)
        registros = cursor.fetchall()

    except mysql.connector.Error:
        if conexao and conexao.is_connected():
            conexao.rollback()
        mensagem = "Não foi possível concluir. Confira os dados e as relações."
        registros = []

    finally:
        if cursor:
            cursor.close()
        if conexao and conexao.is_connected():
            conexao.close()

    opcoes_trilha = "".join(
        f'<option value="{int(t["id_trilha"])}">'
        f'{escape(str(t["nome"]))}</option>'
        for t in trilhas
    )
    opcoes_nivel = "".join(
        f'<option value="{int(n["id_nivel"])}">'
        f'{escape(str(n["nome"]))}</option>'
        for n in niveis
    )

    linhas = ""
    for aula in registros:
        aid = int(aula["id_aula"])
        titulo = escape(str(aula["titulo"]))
        conteudo = escape(str(aula["conteudo"]))
        status = str(aula["status"])
        status_html = escape(status)

        linhas += f"""
        <tr>
            <td>{aid}</td>
            <td>{titulo}</td>
            <td>{escape(str(aula["nome_trilha"]))}</td>
            <td>{escape(str(aula["nome_nivel"]))}</td>
            <td>{status_html}</td>
            <td>
                <details>
                    <summary>Editar</summary>
                    <form method="POST">
                        <input type="hidden" name="acao" value="editar">
                        <input type="hidden" name="id_aula" value="{aid}">
                        <label>Título:</label><br>
                        <input name="titulo" value="{titulo}" required><br>
                        <label>Conteúdo:</label><br>
                        <textarea name="conteudo" required>{conteudo}</textarea><br>
                        <label>Status:</label><br>
                        <select name="status" required>
                            <option value="NAO_INICIADA"
                                {"selected" if status == "NAO_INICIADA" else ""}>Não iniciada</option>
                            <option value="EM_ANDAMENTO"
                                {"selected" if status == "EM_ANDAMENTO" else ""}>Em andamento</option>
                            <option value="CONCLUIDA"
                                {"selected" if status == "CONCLUIDA" else ""}>Concluída</option>
                        </select><br>
                        <label>Trilha:</label><br>
                        <select name="id_trilha" required>
                            {"".join(
                                f'<option value="{int(t["id_trilha"])}" '
                                f'{"selected" if int(t["id_trilha"]) == int(aula["id_trilha"]) else ""}>'
                                f'{escape(str(t["nome"]))}</option>'
                                for t in trilhas
                            )}
                        </select><br>
                        <label>Nível:</label><br>
                        <select name="id_nivel" required>
                            {"".join(
                                f'<option value="{int(n["id_nivel"])}" '
                                f'{"selected" if int(n["id_nivel"]) == int(aula["id_nivel"]) else ""}>'
                                f'{escape(str(n["nome"]))}</option>'
                                for n in niveis
                            )}
                        </select><br>
                        <button type="submit">Salvar alterações</button>
                    </form>
                </details>
                <form method="POST"
                      onsubmit="return confirm('Excluir esta aula?')">
                    <input type="hidden" name="acao" value="excluir">
                    <input type="hidden" name="id_aula" value="{aid}">
                    <button type="submit">Excluir</button>
                </form>
            </td>
        </tr>
        """

    return pagina(f"""
        <p><a href="/">Voltar ao menu</a></p>
        <h1>Gerenciar aulas</h1>
        <p class="mensagem">{escape(mensagem)}</p>

        <form method="POST">
            <h2>Cadastrar aula</h2>
            <input type="hidden" name="acao" value="cadastrar">
            <label>Título:</label><br>
            <input name="titulo" required><br>
            <label>Conteúdo:</label><br>
            <textarea name="conteudo" required></textarea><br>
            <label>Status:</label><br>
            <select name="status" required>
                <option value="NAO_INICIADA">Não iniciada</option>
                <option value="EM_ANDAMENTO">Em andamento</option>
                <option value="CONCLUIDA">Concluída</option>
            </select><br>
            <label>Trilha:</label><br>
            <select name="id_trilha" required>{opcoes_trilha}</select><br>
            <label>Nível:</label><br>
            <select name="id_nivel" required>{opcoes_nivel}</select><br>
            <button type="submit">Cadastrar aula</button>
        </form>

        <h2>Aulas cadastradas</h2>
        <table border="1">
            <tr>
                <th>ID</th><th>Título</th><th>Trilha</th>
                <th>Nível</th><th>Status</th><th>Ações</th>
            </tr>
            {linhas}
        </table>
    """)


@app.route("/conquistas", methods=["GET", "POST"])
def conquistas():
    mensagem = request.args.get("mensagem", "")
    conexao = None
    cursor = None
    registros = []

    try:
        conexao = conectar_banco()
        cursor = conexao.cursor(dictionary=True)

        if request.method == "POST":
            acao = request.form.get("acao", "")
            nome = request.form.get("nome", "").strip()
            descricao = request.form.get("descricao", "").strip()
            criterio = request.form.get("criterio", "").strip()
            id_conquista = request.form.get("id_conquista", "")

            if acao in ("cadastrar", "editar"):
                if not nome or not criterio:
                    mensagem = "Preencha o nome e o critério de desbloqueio."
                else:
                    if acao == "cadastrar":
                        cursor.execute("""
                            INSERT INTO conquista
                            (nome, descricao, criterio_desbloqueio)
                            VALUES (%s, %s, %s)
                        """, (nome, descricao or None, criterio))
                        mensagem = "Conquista cadastrada com sucesso!"
                    else:
                        cursor.execute("""
                            UPDATE conquista
                            SET nome=%s, descricao=%s,
                                criterio_desbloqueio=%s
                            WHERE id_conquista=%s
                        """, (nome, descricao or None, criterio,
                              id_conquista))
                        mensagem = "Conquista atualizada com sucesso!"

                    conexao.commit()

            elif acao == "excluir":
                cursor.execute(
                    "DELETE FROM conquista WHERE id_conquista=%s",
                    (id_conquista,)
                )
                conexao.commit()
                mensagem = "Conquista excluída com sucesso!"

        cursor.execute("""
            SELECT id_conquista, nome, descricao, criterio_desbloqueio
            FROM conquista
            ORDER BY id_conquista
        """)
        registros = cursor.fetchall()

    except mysql.connector.Error:
        if conexao and conexao.is_connected():
            conexao.rollback()
        mensagem = "Não foi possível concluir. Confira os dados."
        registros = []

    finally:
        if cursor:
            cursor.close()
        if conexao and conexao.is_connected():
            conexao.close()

    linhas = ""
    for item in registros:
        identificador = int(item["id_conquista"])
        nome = escape(str(item["nome"]))
        descricao = escape(str(item["descricao"] or ""))
        criterio = escape(str(item["criterio_desbloqueio"]))

        linhas += f"""
        <tr>
            <td>{identificador}</td>
            <td>{nome}</td>
            <td>{descricao}</td>
            <td>{criterio}</td>
            <td>
                <details>
                    <summary>Editar</summary>
                    <form method="POST">
                        <input type="hidden" name="acao" value="editar">
                        <input type="hidden" name="id_conquista"
                               value="{identificador}">
                        <label>Nome:</label><br>
                        <input name="nome" value="{nome}" required><br>
                        <label>Descrição:</label><br>
                        <input name="descricao" value="{descricao}"><br>
                        <label>Critério para desbloquear:</label><br>
                        <input name="criterio" value="{criterio}" required><br>
                        <button type="submit">Salvar alterações</button>
                    </form>
                </details>
                <form method="POST"
                      onsubmit="return confirm('Excluir esta conquista?')">
                    <input type="hidden" name="acao" value="excluir">
                    <input type="hidden" name="id_conquista"
                           value="{identificador}">
                    <button type="submit">Excluir</button>
                </form>
            </td>
        </tr>
        """

    return pagina(f"""
        <p><a href="/">Voltar ao menu</a></p>
        <h1>Gerenciar conquistas</h1>
        <p class="mensagem">{escape(mensagem)}</p>

        <form method="POST">
            <h2>Cadastrar conquista</h2>
            <input type="hidden" name="acao" value="cadastrar">
            <label>Nome:</label><br>
            <input name="nome" required><br>
            <label>Descrição:</label><br>
            <input name="descricao"><br>
            <label>Critério para desbloqueio:</label><br>
            <input name="criterio" required><br>
            <button type="submit">Cadastrar conquista</button>
        </form>

        <h2>Conquistas cadastradas</h2>
        <table border="1">
            <tr>
                <th>ID</th><th>Nome</th><th>Descrição</th>
                <th>Critério</th><th>Ações</th>
            </tr>
            {linhas}
        </table>
    """)

@app.route("/consultas/aulas", methods=["GET", "POST"])
def consulta_aulas():
    status_selecionado = request.values.get("status", "NAO_INICIADA")
    mensagem = ""
    registros = []
    conexao = None
    cursor = None

    status_validos = {
        "NAO_INICIADA": "Não iniciada",
        "EM_ANDAMENTO": "Em andamento",
        "CONCLUIDA": "Concluída"
    }

    if status_selecionado not in status_validos:
        status_selecionado = "NAO_INICIADA"
        mensagem = "Status inválido. Foi selecionado o padrão."

    try:
        conexao = conectar_banco()
        cursor = conexao.cursor(dictionary=True)

        cursor.execute("""
            SELECT a.titulo AS aula,
                   t.nome AS trilha,
                   n.nome AS nivel,
                   a.status
            FROM aula a
            INNER JOIN trilha t ON a.id_trilha = t.id_trilha
            INNER JOIN nivel n ON a.id_nivel = n.id_nivel
            WHERE a.status = %s
            ORDER BY t.nome, n.ordem
        """, (status_selecionado,))

        registros = cursor.fetchall()

    except mysql.connector.Error:
        mensagem = "Não foi possível consultar as aulas. Tente novamente."

    finally:
        if cursor:
            cursor.close()
        if conexao and conexao.is_connected():
            conexao.close()

    linhas = ""
    for aula in registros:
        linhas += f"""
        <tr>
            <td>{escape(str(aula["aula"]))}</td>
            <td>{escape(str(aula["trilha"]))}</td>
            <td>{escape(str(aula["nivel"]))}</td>
            <td>{escape(str(aula["status"]))}</td>
        </tr>
        """

    return pagina(f"""
        <p><a href="/">Voltar ao menu</a></p>
        <h1>Consulta de aulas por status</h1>
        <p>Escolha um status para filtrar as aulas.</p>
        <p class="mensagem">{escape(mensagem)}</p>

        <form method="GET">
            <label>Status da aula:</label><br>
            <select name="status">
                <option value="NAO_INICIADA"
                    {"selected" if status_selecionado == "NAO_INICIADA" else ""}>
                    Não iniciada
                </option>
                <option value="EM_ANDAMENTO"
                    {"selected" if status_selecionado == "EM_ANDAMENTO" else ""}>
                    Em andamento
                </option>
                <option value="CONCLUIDA"
                    {"selected" if status_selecionado == "CONCLUIDA" else ""}>
                    Concluída
                </option>
            </select>
            <button type="submit">Consultar</button>
        </form>

        <h2>Resultado</h2>
        <table border="1">
            <tr>
                <th>Aula</th><th>Trilha</th><th>Nível</th><th>Status</th>
            </tr>
            {linhas}
        </table>
        <p>Total de aulas encontradas: {len(registros)}</p>
    """)

@app.route("/consultas/trilhas", methods=["GET"])
def consulta_trilhas():
    conexao = None
    cursor = None
    trilhas = []
    registros = []
    mensagem = ""

    id_trilha = request.args.get("id_trilha", "")

    try:
        conexao = conectar_banco()
        cursor = conexao.cursor(dictionary=True)

        cursor.execute("SELECT id_trilha, nome FROM trilha ORDER BY nome")
        trilhas = cursor.fetchall()

        if id_trilha:
            cursor.execute("""
                SELECT t.nome AS trilha,
                       n.nome AS nivel,
                       COUNT(a.id_aula) AS total_aulas
                FROM trilha t
                LEFT JOIN aula a ON a.id_trilha = t.id_trilha
                LEFT JOIN nivel n ON a.id_nivel = n.id_nivel
                WHERE t.id_trilha = %s
                GROUP BY t.id_trilha, t.nome, n.id_nivel, n.nome
                ORDER BY n.nome
            """, (id_trilha,))
            registros = cursor.fetchall()

    except mysql.connector.Error:
        mensagem = "Não foi possível consultar as aulas por trilha."

    finally:
        if cursor:
            cursor.close()
        if conexao and conexao.is_connected():
            conexao.close()

    opcoes = '<option value="">Selecione uma trilha</option>'
    for trilha in trilhas:
        tid = int(trilha["id_trilha"])
        selecionada = "selected" if str(tid) == id_trilha else ""
        opcoes += (
            f'<option value="{tid}" {selecionada}>'
            f'{escape(str(trilha["nome"]))}</option>'
        )

    linhas = ""
    total = 0

    for item in registros:
        quantidade = int(item["total_aulas"])
        total += quantidade
        linhas += f"""
        <tr>
            <td>{escape(str(item["trilha"]))}</td>
            <td>{escape(str(item["nivel"] or "Sem nível"))}</td>
            <td>{quantidade}</td>
        </tr>
        """

    return pagina(f"""
        <p><a href="/">Voltar ao menu</a></p>
        <h1>Consulta de aulas por trilha</h1>
        <p class="mensagem">{escape(mensagem)}</p>

        <form method="GET">
            <label>Escolha a trilha:</label><br>
            <select name="id_trilha" required>{opcoes}</select><br>
            <button type="submit">Consultar</button>
        </form>

        <h2>Resultado</h2>
        <table border="1">
            <tr>
                <th>Trilha</th><th>Nível</th><th>Total de aulas</th>
            </tr>
            {linhas}
        </table>
        <p>Total de aulas da trilha: {total}</p>
    """)

@app.route("/relatorio")
def relatorio():
    conexao = None
    cursor = None
    registros = []
    mensagem = ""

    try:
        conexao = conectar_banco()
        cursor = conexao.cursor(dictionary=True)

        cursor.execute("""
            SELECT trilha, nivel, aula, status_aula
            FROM vw_relatorio_aulas
            ORDER BY trilha, nivel, aula
        """)
        registros = cursor.fetchall()

    except mysql.connector.Error:
        mensagem = (
            "Não foi possível gerar o relatório. "
            "Confira se a VIEW existe no banco."
        )

    finally:
        if cursor:
            cursor.close()
        if conexao and conexao.is_connected():
            conexao.close()

    linhas = ""
    for item in registros:
        linhas += f"""
        <tr>
            <td>{escape(str(item["trilha"]))}</td>
            <td>{escape(str(item["nivel"]))}</td>
            <td>{escape(str(item["aula"]))}</td>
            <td>{escape(str(item["status_aula"]))}</td>
        </tr>
        """

    return pagina(f"""
        <p><a href="/">Voltar ao menu</a></p>
        <h1>Relatório consolidado de aulas</h1>
        <p class="mensagem">{escape(mensagem)}</p>
        <p>Este relatório utiliza a VIEW vw_relatorio_aulas do banco.</p>

        <table border="1">
            <tr>
                <th>Trilha</th><th>Nível</th>
                <th>Aula</th><th>Status</th>
            </tr>
            {linhas}
        </table>

        <p>Total de aulas no relatório: {len(registros)}</p>
    """)

if __name__ == "__main__":
    app.run(debug=True)