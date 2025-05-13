//
//  ContentView.swift
//  Titanic
//
//  Created by Ronjie Diafante Man-on on 5/13/25.
//

import SwiftUI
import CoreML

struct MainView: View {
    @State private var titanicModel: TitanicModel = .init(
        passengerClass: "Second Class",
        sex: "Male",
        age: 18,
        siblingsSpouses: 2,
        parentsChildren: 4,
        fare: 5,
        port: "Cherbourg"
    )
    
    @State private var survival: Bool? = nil
    @State private var showAlert = false
    @State private var survivalRate: Double = -1
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    SegmentSectionView(
                        selected: $titanicModel.passengerClass,
                        options: TitanicModel.passengerClasses,
                        sectionTitle: "Passenger Class",
                        prompt: "What passenger class are you?"
                    )
                    
                    SegmentSectionView(
                        selected: $titanicModel.sex,
                        options: TitanicModel.genders,
                        sectionTitle: "Gender",
                        prompt: "What is your gender?"
                    )
                    
                    SliderSectionView(
                        value: $titanicModel.age,
                        sectionTitle: "Age",
                        prompt: "Age: \(titanicModel.age.formatted())",
                        min: 0,
                        max: 120,
                        step: 0.5
                    )
                    
                    SliderSectionView(
                        value: $titanicModel.siblingsSpouses,
                        sectionTitle: "Siblings and Spouses",
                        prompt: "Number of siblings/spouses: \(titanicModel.siblingsSpouses.formatted())",
                        min: 0,
                        max: 10,
                        step: 1
                    )
                    
                    
                    SliderSectionView(
                        value: $titanicModel.parentsChildren,
                        sectionTitle: "Parents and Children",
                        prompt: "Numer of parents and children \(titanicModel.parentsChildren.formatted())",
                        min: 0,
                        max: 10,
                        step: 1
                    )
                    
                    SliderSectionView(
                        value: $titanicModel.fare,
                        sectionTitle: "Ticket price? (in 1910 pounds)",
                        prompt: "Ticket price £\(titanicModel.fare.formatted())",
                        min: 0,
                        max: 600,
                        step: 0.1
                    )
                    
                    SegmentSectionView(
                        selected: $titanicModel.port,
                        options: TitanicModel.ports,
                        sectionTitle: "Port",
                        prompt: "What port did you embark from?"
                    )
                    
                }
                .scrollIndicators(.hidden)
                .blur(radius: showAlert ? 5 : 0)
                .disabled(showAlert)
                
                if showAlert {
                    Button {
                        withAnimation {
                            showAlert.toggle()
                        }
                    } label: {
                        if let survival {
                            VStack {
                                Text(survival ? "SURVIVED!" : "DID NOT SURVIVE")
                                
                                Text("Probability of Survival: \(survivalRate)")
                            }
                            .padding()
                            .background(Color.black)
                            .foregroundStyle(.white)
                        }
                    }
                }
            }
            .navigationTitle("Surviving the Titanic")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        compute()
                    } label: {
                        Text("Compute")
                            .bold()
                            .foregroundStyle(Color.red)
                            .opacity(showAlert ? 0 : 1)
                    }
                }
            }
        }
    }
    
    func compute() {
        do {
            let config = MLModelConfiguration()
            let model = try TitanicRegressionModel(configuration: config)
            let prediction = try model
                .prediction(
                    Pclass: titanicModel.Pclass,
                    Sex: titanicModel.sex.lowercased(),
                    Age: titanicModel.age,
                    SibSp: Int64(titanicModel.siblingsSpouses),
                    Parch: Int64(titanicModel.parentsChildren),
                    Fare: titanicModel.fare,
                    Embarked: String(titanicModel.port.first ?? "C")
                )
            
            survivalRate = prediction.Survived
            
            survival = prediction.Survived > 0.5
            
        } catch {
            survival = nil
        }
        showAlert = true
    }
}

#Preview {
    MainView()
}
