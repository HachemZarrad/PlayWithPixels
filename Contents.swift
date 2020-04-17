//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

var RGBA = RGBAImage(image: image)!

// Process the image!


protocol Filters {
    var order : Int { get }
    var gradation : Int {get}
    func onePixel(inout pixel:UInt8)
    
}

protocol FIlterType {
    var name : String {get}
    mutating func wholeFilter() -> UIImage
}

struct Reddish:Filters,FIlterType{
    let name: String = "Reddish"
    let redAvg = 118
    var gradation = 0
    var order = 0
    
    init(gradation : Int , order : Int){
        self.gradation = gradation
        self.order = order
    }
    
   init(gradation : Int){
        self.gradation = gradation
    }
    
    func onePixel(inout pixel:UInt8){
        if gradation > 0 {
            pixel = UInt8(max(0,min(255, redAvg + gradation*5)))
            
       }
    }
    
    mutating func wholeFilter() -> UIImage{
        var RGBA = RGBAImage(image: image)!
        for y in 0..<RGBA.width{
            for x in 0..<RGBA.height{
                let index = y * RGBA.width + x
                var pixel = RGBA.pixels[index]
                pixel.red = UInt8(max(0,min(255, gradation*10)))
                RGBA.pixels[index] = pixel
                    }
        }
        return RGBA.toUIImage()!
    }
}

struct Bluish:Filters,FIlterType{
    let name: String = "Bluish"
    let blueAvg = 83
    var gradation = 0
    var order = 0
    
    init(gradation : Int){
        self.gradation = gradation
    }
    
    init(gradation : Int , order : Int){
        self.gradation = gradation
        self.order = order
    }


    
    func onePixel(inout pixel:UInt8){
        if gradation > 0 {
            pixel = UInt8(max(0,min(255, blueAvg + gradation*5 )))
            }
     }
    
    mutating func wholeFilter()-> UIImage{
        var RGBA = RGBAImage(image: image)!
        for y in 0..<RGBA.width{
            for x in 0..<RGBA.height{
                let index = y * RGBA.width + x
                var pixel = RGBA.pixels[index]
                pixel.blue = UInt8(max(0,min(255, gradation*10)))
               RGBA.pixels[index] = pixel
            }
        }
        return RGBA.toUIImage()!
    }

}

struct Greenish:Filters,FIlterType{
        let name: String = "greenish"
        let greenAvg = 98
        var gradation = 0
        var order = 0
    
    init(gradation : Int){
        self.gradation = gradation
    }
    
    init(gradation : Int , order : Int){
        self.gradation = gradation
        self.order = order
    }


    
        func onePixel(inout pixel:UInt8){
            if gradation > 0 {
            pixel = UInt8(max(0,min(255, greenAvg + gradation*5)))
            }
    }
    
    mutating func  wholeFilter()-> UIImage{
        var RGBA = RGBAImage(image: image)!
        for y in 0..<RGBA.width{
            for x in 0..<RGBA.height{
                let index = y * RGBA.width + x
                var pixel = RGBA.pixels[index]
                pixel.green = UInt8(max(0,min(255, gradation*10)))
                RGBA.pixels[index] = pixel
            }
        }
        return RGBA.toUIImage()!
    }

}

struct ImageProcessor {
    var reddishOrder = 0
    var bluishOrder = 0
    var greenishOrder = 0
    var reddishInput = 0
    var bluishInput = 0
    var greenishInput = 0
    var singleFilterGradation = 0
    
    init(reddishOrder : Int, bluishOrder : Int, greenishOrder : Int, reddishInput : Int, bluishInput :Int, greenishInput : Int ){
        self.reddishOrder = reddishOrder
        self.bluishOrder = bluishOrder
        self.greenishOrder = greenishOrder
        self.reddishInput = reddishInput
        self.bluishInput = bluishInput
        self.greenishInput = greenishInput
    }
    
    init(singleFilterGradation : Int) {
        self.singleFilterGradation = singleFilterGradation
    }
    
    
    func specificFilter(filterName : String) -> UIImage {
        var  pic : UIImage?
        switch filterName {
            case "Reddish":
                var redFilter = Reddish(gradation: singleFilterGradation)
                pic = redFilter.wholeFilter()
            case "Bluish" :
                var blueFilter = Bluish(gradation: singleFilterGradation)
                pic = blueFilter.wholeFilter()
            case "Greenish" :
                var greenFilter = Greenish(gradation: singleFilterGradation)
                pic = greenFilter.wholeFilter()
            default:
                pic = UIImage(named: "sample")!
                print("Enter correct filter name")
        }
            return pic!
    }
    
    func filtersPipeline() -> UIImage{
        if (1...3 ~= reddishOrder  &&  1...3 ~= bluishOrder    &&  1...3 ~= greenishOrder) && (reddishOrder != bluishOrder)  && (bluishOrder != greenishOrder) && (reddishOrder != greenishOrder)  {
       
        for y in 0..<RGBA.width{
            for x in 0..<RGBA.height{
                let index = y * RGBA.width + x
                var pixel = RGBA.pixels[index]
                let redDiff = Int(pixel.red) - reddishInput
                let blueDiff = Int(pixel.blue) - bluishInput
                let greenDiff = Int(pixel.green) - greenishInput
                let redFilter = Reddish(gradation: redDiff,order: reddishOrder)
                let blueFilter = Bluish(gradation: blueDiff,order: bluishOrder)
                let greenFilter = Greenish(gradation: greenDiff,order: greenishOrder)
                switch reddishOrder{
                    case 1:
                        if bluishOrder == 2 {
                            redFilter.onePixel(&pixel.red)
                            blueFilter.onePixel(&pixel.blue)
                            greenFilter.onePixel(&pixel.green)
                  
                                            }
                    else{
                            redFilter.onePixel(&pixel.red)
                            greenFilter.onePixel(&pixel.green)
                            blueFilter.onePixel(&pixel.blue)
                    }
                case 2:
                    if bluishOrder == 1 {
                        blueFilter.onePixel(&pixel.blue)
                        redFilter.onePixel(&pixel.red)
                        greenFilter.onePixel(&pixel.green)
                    }
                    else{
                        greenFilter.onePixel(&pixel.green)
                        redFilter.onePixel(&pixel.red)
                        blueFilter.onePixel(&pixel.blue)
                    }
                case 3:
                    if bluishOrder == 1 {
                        blueFilter.onePixel(&pixel.blue)
                        greenFilter.onePixel(&pixel.green)
                        redFilter.onePixel(&pixel.red)
                    }
                    else{
                        greenFilter.onePixel(&pixel.green)
                        blueFilter.onePixel(&pixel.blue)
                        redFilter.onePixel(&pixel.red)
                    }
                default:
                        print(image)

                }
                RGBA.pixels[index] = pixel
            }
        }
        }
        else {
            print("Please give filters seperate orders from 1 to 3")
        }

        let finalPic =  RGBA.toUIImage()!
        return finalPic
    }
    }

let finalPic = ImageProcessor(reddishOrder: 1, bluishOrder: 3, greenishOrder: 2, reddishInput: 255, bluishInput: 55, greenishInput: 80)
finalPic.filtersPipeline()
let onePic = ImageProcessor(singleFilterGradation: 150)
onePic.specificFilter("Reddish")
onePic.specificFilter("Bluish")
onePic.specificFilter("Greenish")
onePic.specificFilter("wrong filter name")






