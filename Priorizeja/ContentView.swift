//
//  ContentView.swift
//  Dicas_alimentacao
//
//  Created by user on 28/11/24.
//

import SwiftUI



struct ContentView: View {
    @State private var mostrarSplash = true
    @State private var lembretes: [Lembrete] = UserDefaults.standard.loadLembretes()

    var body: some View {
        ZStack {
            if mostrarSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            mostrarSplash = false
                        }
                    }
            } else {
                MainView(lembretes: $lembretes)
                    .onChange(of: lembretes) { novosLembretes in
                        UserDefaults.standard.saveLembretes(novosLembretes)
                    }
            }
        }
    }
}

// Tela principal com lembretes e configurações
struct MainView: View {
    @Binding var lembretes: [Lembrete]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: ConfiguracoesView()) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                }

                Text("Seus Lembretes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(lembretes) { lembrete in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(lembrete.titulo)
                                        .font(.title2)
                                        .foregroundColor(.black)

                                    Text("\(lembrete.horario.formatted())")
                                        .font(.subheadline)
                                        .foregroundColor(.black)

                                    Text(lembrete.descricao)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(14)

                                Spacer()

                                // Botão de excluir
                                Button(action: {
                                    if let index = lembretes.firstIndex(of: lembrete) {
                                        lembretes.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .padding()
                                }
                            }
                        }
                    }
                    .padding()
                }

                Spacer()

                HStack {
                    Spacer()
                    NavigationLink(destination: CriarLembreteView { novoLembrete in
                        lembretes.append(novoLembrete)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}


// Tela de criação de lembretes
struct CriarLembreteView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var titulo = ""
    @State private var descricao = ""
    @State private var horario = Date()
    @State private var data = Date()
    let onSalvar: (Lembrete) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("Título", text: $titulo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Definir horário", selection: $horario, displayedComponents: .hourAndMinute)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)

            DatePicker("Definir data", selection: $data, displayedComponents: .date)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)

            TextField("Descrição", text: $descricao)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Salvar") {
                let novoLembrete = Lembrete(id: UUID(), titulo: titulo, descricao: descricao, horario: horario, data: data)
                onSalvar(novoLembrete)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// Tela de configurações
struct ConfiguracoesView: View {
    @State private var alarmeAtivo = false
    @State private var musicaSelecionada = "Padrão"
    @State private var vibracaoAtiva = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Toggle("Toque de Alarme", isOn: $alarmeAtivo)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .foregroundColor(.white)

            NavigationLink(destination: EscolherMusicaView(musicaSelecionada: $musicaSelecionada)) {
                HStack {
                    Text("Toque do Timer")
                    Spacer()
                    Text(musicaSelecionada).foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            }

            Toggle("Ativar/Desativar Vibração", isOn: $vibracaoAtiva)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .foregroundColor(.white)

            Spacer()
        }
        .padding()
        .navigationTitle("Configurações")
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// Tela para escolher a música do timer
struct EscolherMusicaView: View {
    @Binding var musicaSelecionada: String
    let musicas = ["Padrão", "Jazz", "Rock", "Clássica"]

    var body: some View {
        List(musicas, id: \.self) { musica in
            Button(musica) {
                musicaSelecionada = musica
            }
            .foregroundColor(.white)
        }
        .navigationTitle("Escolher Música")
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// Splash Screen
struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "note")
                    .imageScale(.large)
                    .foregroundColor(.black)

                Text("PriorizeJá!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

