//
//  ContentView.swift
//  News
//
//  Created by Alvin Sena Nutor on 28/05/2020.
//  Copyright © 2020 Alvin Sena Nutor. All rights reserved.
//

//The following Imports help to allows my code to access symbols that are declared in other files.
import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit

//The struct = To provides storage of data using
//properties with extended functionality using methods
struct ContentView: View {
    
    
// It ensures that the property for getting the data  is watched closely so that important changes will reload any views using it from the list of data.
    @ObservedObject var list = getData()
    var body: some View {
        NavigationView{
            List(list.datas){i in
                
                
                //Basically it is used to navigate between views with specific dimentions being put in place to fit the format of the Mobile app.
                NavigationLink(destination:
                    webView(url: i.url)
                        .navigationBarTitle("",displayMode: .inline)
                    ){
                        //Allowing arrangement of child views in a horizontal line
                    HStack(spacing: 15){
                        //Allowing arrangement of child views in a vertical line
                            VStack(alignment: .leading, spacing: 10){
                                
                                //Text specification in terms of its font and limit.
                                Text(i.title).fontWeight(.heavy)
                                Text(i.desc).lineLimit(2)
                            }
                            
                        //if statement executes a certain section of code if the test expression is evaluated to true.
                            if i.image != ""{
                                
                                //URL with specific dimensions
                                WebImage(url: URL(string: i.image)!, options: .highPriority, context: nil)
                                .resizable()
                                .frame(width: 130, height: 135)
                                .cornerRadius(20)
                            }
                    
                            
                     // Returns a new string formed from the receiver by either removing characters from the end, or by appending
                        }.padding(.vertical,15)
                }
                
                //To set the title of the navigation bar
            }.navigationBarTitle("Headlines")
     }
   }
 }
      
      
//The struct = provides storage of data using
//properties with extended functionality using methods
//To enable the User to See the preview of the News(Data)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//The struct = provides storage of data using
//properties with extended functionality using methods
struct dataType : Identifiable{
    // Var = Variables store and refer to values by identifying their name.
    var id : String
    var title : String
    var desc : String
    var url : String
    var image : String
    
}

//Creation of a blueprint or template for an instance of that class getData.
class getData : ObservableObject{
    //Allowing creation of observable objects that automatically announce when changes occur in the news(or news updated).
    @Published var datas = [dataType]()
    //For preparing an instance of a class
    init(){
        
        //immutable variable = (it cannot be changed) basically it is a constant
        let source = "https://newsapi.org/v2/top-headlines?country=us&apiKey=8468d3e24f614f959062cd9645b04e9d"
        
        //immutable variable url
        let url = URL(string: source)!
        
        //immutable variable session
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, _, err) in
            

            //if statement being created is used to executes a certain section of code(the immutable variables(constants) if the test expression is evaluated to true.
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            
            let json = try! JSON(data: data!)
            
            for i in json["articles"]{
                
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let image = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                
                //DispatchQueue.main.async {
                    self.datas.append(dataType(id: id, title: title, desc: description,
                    url: url, image: image))
                }
        
            //Runs and does the program terminate
            //and does not wait for a server response.
            }.resume()
            
        }
   }

//The struct = provides storage of data using
//properties with extended functionality using methods from the
//UIViewRepresentable instance to create and manage a UIView object in your SwiftUI interface.
struct webView : UIViewRepresentable{
    
    //Variable named url with a datatype String
    var url : String
    
    //A function perform a specific task named makeUIView.
    func makeUIView(context: UIViewRepresentableContext<webView>) ->WKWebView{
        
        //immutable variable to view(WKWebView) which is also used to view a class that can be used to display interactive web content in xcode iOS app.
        let view = WKWebView()
        view.load(URLRequest(url:URL(string:url)!))
        //returns view
        return view
    }

    
    // Perform a specific task named updateUIView(Update the data or the News).
        func updateUIView(_ uiView: WKWebView, context:
            UIViewRepresentableContext<webView>) {
        }
    }
