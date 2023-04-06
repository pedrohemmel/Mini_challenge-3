//
//  TelaDesenharView.swift
//  Mini_Challenge-3
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 28/03/23.
//

import SwiftUI
import AVFoundation

struct TelaDesenharView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var dismissDasTelas: (() -> Void)
    
    @Binding var dadosImagemSelecionada: Data
    @Binding var desenhoSelecionado: String
    @Binding var voltaParaTelaInicial: Bool
    
    @State var eDesenho: Bool? = nil
    @State var estaTravado = false
    
    @State private var escalaZoom = 0.0
    @State private var opacidadeFundo = 0.0
    @State private var opacidadeImagem = 0.5
    
    @StateObject var cameraViewModel = ModoCameraViewModel()
    
    let telaDesenharViewModel = TelaDesenharViewModel()
    
    let larguraTela = UIScreen.main.bounds.size.width
    let alturaTela = UIScreen.main.bounds.size.height
    
    var body: some View {
        ZStack {
            ModoCameraRepresentable(cameraViewModel: self.cameraViewModel)
                .ignoresSafeArea(.all)
            Rectangle()
                .frame(width: larguraTela, height: alturaTela)
                .ignoresSafeArea(.all)
                .foregroundColor(.white)
                .opacity(self.opacidadeFundo)
                
            
            VStack {
                if self.eDesenho ?? false {
                    Image(self.desenhoSelecionado)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: larguraTela)
                        .opacity(self.opacidadeImagem)
                } else {
                    if let uiImage = UIImage(data: self.dadosImagemSelecionada) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: larguraTela)
                            .opacity(self.opacidadeImagem)
                    }
                }
            }
            if !self.estaTravado {
                VStack {
                    Spacer()
                    VStack {
                        SliderComponente(titulo: "Lupa", medida: self.$escalaZoom)
                        SliderComponente(titulo: "Imagem", medida: self.$opacidadeImagem)
                        SliderComponente(titulo: "Fundo", medida: self.$opacidadeFundo)
                    }
                    .padding()
                    .background(self.colorScheme == .dark ? .black : .white)
                    .cornerRadius(10)
                    .padding()
                    .padding(.bottom, alturaTela * 0.1)
                    .opacity(0.8)
                    .onChange(of: escalaZoom) { escala in
                        self.telaDesenharViewModel.alterarZoom(escala: CGFloat(escala))
                    }
                }
                
            }
        }
        .onAppear {
            self.eDesenho = self.telaDesenharViewModel.verificaImagemNula(dadosImagemSelecionada: self.dadosImagemSelecionada, desenhoSelecionado: self.desenhoSelecionado)
        }
        .onAppear(perform: cameraViewModel.checarPermissao)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.estaTravado = !self.estaTravado
                } label: {
                    if !self.estaTravado {
                        Image(systemName: "lock.open.fill")
                            .font(.system(size: 25))
                            .foregroundColor(self.opacidadeFundo <= 0.5 ? .accentColor : Color("texts"))
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 25))
                            .foregroundColor(self.opacidadeFundo <= 0.5 ? .accentColor : Color("texts"))
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if !self.estaTravado {
                    Button {
                        self.dadosImagemSelecionada = Data()
                        self.desenhoSelecionado = ""
                        self.voltaParaTelaInicial = true
                        self.dismiss()
                        self.dismissDasTelas()
                    } label: {
                        Text("Concluir")
                            .fontWeight(.bold)
                            .foregroundColor(self.opacidadeFundo <= 0.5 ? .accentColor : Color("texts"))
                    }
                }
            }
                
        }
    }
    
    
    
    
}
