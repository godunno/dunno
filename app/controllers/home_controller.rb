class HomeController < ApplicationController
  def home
    @features = [
      {
        description: 'Envie lembretes por e-mail.',
        icon: 'icon-buzz'
      }, {
        description: 'Tenha uma visão geral das suas aulas.',
        icon: 'icon-task-list'
      }, {
        description: 'Seus conteúdos organizados.',
        icon: 'icon-catalog'
      }, {
        description: 'Compartilhe facilmente seus arquivos.',
        icon: 'icon-calendar'
      }
    ]
    @slides = [
      {
        title: 'Notifique seus estudantes.',
        content: [
          'Tem um novo material importante, não terá uma aula ou você só quer relembrar seus estudantes do trabalho que é para a semana que vem?',
          'Envie uma mensagem para os estudantes através do Dunno, e eles receberão por e-mail.'
        ]
      }, {
        title: 'Seu diário, suas escolhas.',
        content: [
          'O diário de cada aula tem o conteúdo que você envia especificamente para aquela aula.',
          'Tem uma prova surpresa ou um lembrete só pra você? Marque o conteúdo como privado e seus estudantes não terão acesso.',
          'Você também decide quando os estudantes poderão acessar a aula que você preparou.'
        ]
      }, {
        title: 'Os materiais da sua aula facilmente acessíveis.',
        content: [
          'Precisa enviar todo o material já dado na sua aula para alguém que foi transferido?',
          'Seus arquivos e links estão organizados e são de fácil acesso tanto para você quanto para os seus estudantes.'
        ]
      }, {
        title: 'Organizado e simples.',
        content: [
          'Não importa se você dá aulas em mais de uma turma ou instituição: suas aulas e seus conteúdos estão em um único lugar!'
        ]
      }
    ]
    @testimonials = [
      {
        name: 'Maria Joaquina Villaseñor',
        from: 'Estudante do Ensino Fundamental na Escola Mundial',
        quote: 'Estudar ficou muito mais fácil com o Dunno. Uso em aula e em casa para acompanhar as novidades que a professora compartilha.',
        photo: 'site/testimonials-picture-2.jpg'
      }, {
        name: 'Godinez',
        from: 'Estudante da escola pública do Chaves',
        quote: 'Melhorei minhas notas e agora não preciso mais jogar a moeda para fazer as provas.',
        photo: 'site/testimonials-picture-3.jpg'
      }, {
        name: 'Girafales',
        from: 'Professor da escola pública do Chaves',
        quote: 'Por que causa, motivo, razão ou circunstância? Que foi que você disse? Tá Tá Tá Tá Tá Tá! Silêncio!',
        photo: 'site/testimonials-picture-4.jpg'
      }
    ]
  end
end
