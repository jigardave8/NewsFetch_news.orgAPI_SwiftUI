//
//  ContentView.swift
//  iGuru_assignment
//
//  Created by Jigar on 05/12/22.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import SwiftyJSON
import WebKit

struct ContentView: View {
    
    @ObservedObject var list = getData()
    
    var body: some View {
        NavigationView{
            List(list.datas){ i in
                NavigationLink(destination:
                                webView(url: i.url)
                    .navigationBarTitle("", displayMode: .inline))
                {
                    HStack{
                        VStack(alignment: .trailing)
                        {
                            Text(i.title) .fontWeight(.bold)
                                .padding(.vertical,1)
//
                            
                            Text(i.desc).lineLimit(3)
                                .fontWeight(.light)
                            //                            AsyncImage(url: URL(string: i.image), scale: 2.0)
                            
                        }
                        if i.image !=  ""{
                            WebImage(url: URL(string: i.image)!, options: .highPriority, context: nil)
                                .resizable()
                                .scaledToFit()
                            
                            .cornerRadius(20).padding()}
                        
                    } .padding(.vertical,5)
                        .padding(.horizontal,4)
                    
                }.navigationBarTitle("HeadLines")
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct dataType: Identifiable
{
    var id: String
    var title: String
    var desc: String
    var url : String
    var image: String
    
}

class getData: ObservableObject {
    
    @Published var datas = [dataType]()
    
    init(){
        
        let source =
        //"https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=90eaa6ce6605476bbddf39c74ba34bd5"
        
        "https://newsapi.org/v2/everything?q=apple&from=2022-12-04&to=2022-12-04&sortBy=popularity&apiKey=90eaa6ce6605476bbddf39c74ba34bd5"
        
        let url = URL(string: source)!
        let session = URLSession(configuration: .default)
        session.dataTask(with: url){ (data, _, err) in
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            let json = try! JSON(data: data!)
            
            for i in json["articles"]
            {
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let image = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                
                
                self.datas.append(dataType(id: id, title: title, desc: description, url: url, image: image))
                
            }
        }.resume()
        
    }
}

struct webView : UIViewRepresentable{
    
    var url: String
    func makeUIView(context: UIViewRepresentableContext<webView>) -> WKWebView{
        
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<webView>)
    {
        
    }
}




