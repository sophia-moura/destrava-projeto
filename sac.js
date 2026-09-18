const formSAC = document.getElementById("formSAC");
const mensagem = document.getElementById("mensagem-sac");

formSAC.addEventListener("submit", function(event) {

    event.preventDefault();

    mensagem.textContent = "Mensagem enviada com sucesso!";

    formSAC.reset();

});