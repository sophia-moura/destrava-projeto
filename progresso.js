document.addEventListener("DOMContentLoaded", function () {

    const totalAulas = 12;
    let aulasConcluidas = 0;

    const progressBar = document.getElementById("progressBar");
    const progressText = document.getElementById("progressText");
    const btnConcluir = document.getElementById("btnConcluir");
    const aulasAssistidas = document.getElementById("aulasAssistidas");
    const modulo2 = document.getElementById("modulo2");
    const modulo3 = document.getElementById("modulo3");

    const statusModulo2 =
        document.getElementById("statusModulo2");

    const statusModulo3 =
        document.getElementById("statusModulo3");

    // Verifica se os elementos foram encontrados
    if (
        !progressBar ||
        !progressText ||
        !btnConcluir ||
        !aulasAssistidas ||
        !modulo2 ||
        !modulo3 ||
        !statusModulo2 ||
        !statusModulo3
    ) {
        console.error("Erro: algum elemento do progresso não foi encontrado.");
        return;
    }

    // Atualização do progresso
    function atualizarProgresso() {

        // Calcula a porcentagem
        const porcentagem = Math.round(
            (aulasConcluidas / totalAulas) * 100
        );


        // Atualiza a barra
        progressBar.style.width = porcentagem + "%";


        // Atualiza a porcentagem
        progressText.textContent =
            porcentagem + "% concluído";


        // Atualiza quantidade de aulas
        aulasAssistidas.textContent =
            aulasConcluidas +
            " de " +
            totalAulas +
            " aulas assistidas";


        // Quando chegar a 100%
        if (aulasConcluidas === totalAulas) {

    btnConcluir.textContent =
        "✓ Módulo concluído";

    btnConcluir.disabled = true;

    // Desbloqueia o próximo módulo
    desbloquearModulo2();

}

    }

    function desbloquearModulo2() {

        modulo2.classList.remove("locked");
        modulo2.classList.add("unlocked");

        modulo2.querySelector(".item-status-icon").textContent = "🔓";

        statusModulo2.textContent =
            "Desbloqueado — Você pode começar este módulo";

    }

    function desbloquearModulo3() {

        modulo3.classList.remove("locked");
        modulo3.classList.add("unlocked");

        modulo3.querySelector(".item-status-icon").textContent = "🔓";

        statusModulo3.textContent =
            "Desbloqueado — Você pode começar este módulo";

    }

    // Botão Concluir Aula

    btnConcluir.addEventListener("click", function () {

        // Verifica se ainda existem aulas
        if (aulasConcluidas < totalAulas) {

            aulasConcluidas++;

            atualizarProgresso();

        }

    });

    atualizarProgresso();

});