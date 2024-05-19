import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Image("Logo_Image")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fit)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                Spacer()
                    .frame(height: geometry.size.height / 4) // Adjust as needed for spacing
                Text("My Habits")
                    .font(.custom("SF Pro Display Semibold", size: 20))
                    .foregroundColor(Color(red: 161 / 255, green: 22 / 255, blue: 204 / 255))
                    .padding(.top, 20)
            }
            .background(Color.white)
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}

