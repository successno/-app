//
//  ChartView.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/18.
//

import SwiftUI

struct ChartView: View {
    
    private  let data:[Double]
    private let maxY:Double
    private  let minY:Double
    private let lineColor:Color
    private let startingDate: Date
    private let endingDate:Date
    @State private var percentge:CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        // 价格变化的量
        let priceChange = (data.last ?? 0 ) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoSrting: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    // 假设有 一个宽度为300的屏幕
    //数据有100 条
    //将300/100 =3
    //有3个额外的点 x
    //索引为 0 则加 1 获得 1
    //那么 1*3 = 3
    //第二个项是1 那么1+1 为 2  2*3 = 6
    // x就会从3一直到300
    
    
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBarkgroud )
                .overlay (高度.padding(.horizontal,4) , alignment: .leading)
            chartDateLables
                .padding(.horizontal,4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)){
                    percentge = 1.0
                }
            }
        }
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
       
}

extension ChartView {
    
    private var chartView:some View{
        GeometryReader { geometry in
            //Path { path in：创建一个 Path 实例，path 是闭包参数，用于描述路径的构建逻辑。Path 是用于定义形状的结构体，在 SwiftUI 中常用于绘制自定义图形。
            Path{
                path in
                for index in data.indices{
                    
                    //计算每个点的 x 坐标位置。它通过获取屏幕的宽度（UIScreen.main.bounds.width），将其按 data 数组的元素数量进行平均划分（/ CGFloat(data.count)），再乘以当前索引加 1（* CGFloat(index + 1)），得到每个点对应的 x 坐标。这样可以均匀地在屏幕宽度上分布这些点。
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    //差值
                    let yAxis = maxY - minY
                    //当前值减去最小值 获取到差值的百分比 就是 图表的高度， 将 图表实际高度 乘 视图的高度
                    //因为 iphone 的零点在顶部 所以拿 1 减去 原来的就反转
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis )) * geometry.size.height
                    
                    //如果当前索引是 0，即处理第一个点时，使用 path.move(to:) 方法将路径的起点移动到坐标 (0, 0)。这个方法只是设置路径的起始位置，不会绘制线条。
                    if index == 0 {
                        //将起点设为第一个x的位置和y的位置
                        path.move(to: CGPoint(x: xPosition,y: yPosition))
                    }
                    //添加一条从当前路径位置到指定点 (xPosition, 0) 的线段。在循环中，每次迭代都会从当前位置（可能是上一次添加线段的终点，或者是起点如果是第一次迭代）绘制一条水平线段到计算出的新 x 坐标位置，y 坐标始终为 0，这意味着所有线段都是水平的
                    path.addLine(to: CGPoint(x:xPosition , y : yPosition))
                    
                }
            }
           
            //修剪
            .trim(from: 0,to: percentge)
            //这是对前面构建的 Path 进行绘制的操作。stroke 方法用于绘制路径，它接受两个主要参数：
            //Color.blue：指定绘制线条的颜色为蓝色。
            //style: StrokeStyle(lineWidth: 10,lineCap:.round,lineJoin:.round)：设置绘制线条的样式。lineWidth: 2 表示线条宽度为 2 个点；lineCap:.round 表示线条端点为圆形；lineJoin:.round 表示线条连接点为圆形，这些设置使绘制的线条看起来更加圆润、平滑。
            .stroke(lineColor,style: StrokeStyle(lineWidth: 2,lineCap: .round,lineJoin: .round))
            .shadow(color: lineColor, radius: 10,x: 0.0,y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10,x: 0.0,y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10,x: 0.0,y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10,x: 0.0,y: 40)
            
        }
    }
    
    private var chartBarkgroud: some View {
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var 高度:some View{
        VStack{
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text( ((maxY + minY) / 2 ).formattedWithAbbreviations() )
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
        
    }
    
    private var chartDateLables:some View{
        HStack{
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
    
    
}
