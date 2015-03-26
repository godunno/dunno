require './app/services/abbreviate'
require 'pry'

describe Abbreviate do
  it { expect(Abbreviate.new("Programação").abbreviate).to eq("P") }
  it { expect(Abbreviate.new("programação").abbreviate).to eq("P") }
  it { expect(Abbreviate.new("Programação 1").abbreviate).to eq("P1") }
  it { expect(Abbreviate.new("Programação I").abbreviate).to eq("PI") }
  it { expect(Abbreviate.new("Programação IV").abbreviate).to eq("PIV") }
  it { expect(Abbreviate.new("programação iii").abbreviate).to eq("PIII") }
  it { expect(Abbreviate.new("Cálculo Diferencial e Integral Aplicado para Computação II").abbreviate).to eq("CDIACII") }
  it { expect(Abbreviate.new("Conjunções e Preposições: e ou para de da que").abbreviate).to eq("CP") }
  it { expect(Abbreviate.new("Nome Realmente Muito Longo de Disciplina de Graduação que Possui Mais de Dez Caracteres II").abbreviate).to eq("NRMLDGPMDC") }

  it "should have a constructor method" do
    abbreviator = spy('Abbreviate')
    name = "Cálculo I"
    allow(Abbreviate).to receive(:new).with(name).and_return(abbreviator)
    Abbreviate.abbreviate(name)
    expect(abbreviator).to have_received(:abbreviate)
  end
end
