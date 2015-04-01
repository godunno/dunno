require 'spec_helper'

describe NotificationFormatter do
  let(:formatter) { NotificationFormatter.new(message) }
  let(:formatted_message) { formatter.format }

  context "handling acute glyphs" do
    let(:message) { "áéíóú" }

    it { expect(formatted_message).to eq "aeiou" }
  end

  context "handling cedillas" do
    let(:message) { "ç" }

    it { expect(formatted_message).to eq "c" }
  end

  context "handling a message normally sent" do
    let(:message) { "[Dunno] PROG I - Ó venham, amigões! Vamos fazer a magia da programação!" }

    it { expect(formatted_message).to eq "[Dunno] PROG I - O venham, amigoes! Vamos fazer a magia da programacao!" }
  end

  context "handling lots of glyphs, uppercase and downcase" do
    let(:message) { "ÁÉÍÓÚáéíóú ÀÈÌÒÙàèìòù ÃÕãõ Çç Üü" }

    it { expect(formatted_message).to eq "AEIOUaeiou AEIOUaeiou AOao Cc Uu" }
  end
end
