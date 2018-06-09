//
//  hotel.swift
//  assgn4
//
//  Created by Chintan Dinesh Koticha on 2/17/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//

import Foundation
import CoreData

var cList : Array<Customer> = Array()
var rList : Array<Room> = Array()
var bList : Array<Booking> = Array()

var roomdetails:String = ""
var displayBookings:String = ""
var searchBookings:String = ""

func makedisplayBookingsString() -> String{
    var cnt:Int = 0;
    let context = getContext()
    
    var getBookingList: [Booking] = []
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Booking")
    do{
        getBookingList = try context.fetch(request) as! [Booking]
    }catch{
        print("Failed in Booking - Retreive Room List")
    }
    
    if(getBookingList.isEmpty){
        displayBookings = "NO BOOKINGS YET!!"
        return displayBookings
    }
    
    for book in getBookingList{
        let dateFormatter1 = DateFormatter()
        dateFormatter1.timeStyle = DateFormatter.Style.none
        dateFormatter1.dateStyle = DateFormatter.Style.short
        
        let fromDate1 = dateFormatter1.string(from: book.fromDate! as Date)
        let toDate1 = dateFormatter1.string(from: book.toDate! as Date)
        let today = dateFormatter1.string(from: NSDate() as Date)
        if(fromDate1 <= today && toDate1 >= today ){
            cnt += 1
            displayBookings = displayBookings + "----BOOKING NO: "+String(cnt) + "----"
            displayBookings = displayBookings + "\n" + "BOOKING NAME: "+book.bookingName!
            displayBookings = displayBookings + "\n" + "FROM DATE: "+String(describing: book.fromDate!)
            displayBookings = displayBookings + "\n" + "TO DATE: "+String(describing: book.toDate!)
            displayBookings = displayBookings + "\n" + "ROOM NUMBER: "+(book.room?.roomName)!
            displayBookings = displayBookings + "\n" + "CUSTOMER ID: "+(book.cust?.custId)!
            displayBookings = displayBookings + "\n" + "CUSTOMER NAME: "+(book.cust?.custName)!
            displayBookings = displayBookings + "\n\n"
        }
    }
    
    if(cnt==0){
        displayBookings = displayBookings + "NO BOOKINGS FOR TODAY!!"
    }
    return displayBookings
}

func makeRoomDetailsString() -> String {
    var tempString:String = ""
    
    var booked : Array<Room> = Array()
    var vacant : Array<Room> = Array()
    var bflag:Bool = false
    let context = getContext()
    var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Room")
    
    var getRoomList: [Room] = []
    do{
        getRoomList = try context.fetch(request) as! [Room]
    }catch{
        print("Failed in Booking - Retreive Room List")
    }
    
    var getBookingList: [Booking] = []
    request = NSFetchRequest<NSFetchRequestResult>(entityName: "Booking")
    do{
        getBookingList = try context.fetch(request) as! [Booking]
    }catch{
        print("Failed in Booking - Retreive Room List")
    }
    
    if getRoomList.isEmpty{
        tempString = "NO ROOMS IN THE HOTEL!!"
        return tempString
    }
    for room in getRoomList{
        bflag = false
        for book in getBookingList{
            let dateFormatter1 = DateFormatter()
            dateFormatter1.timeStyle = DateFormatter.Style.none
            dateFormatter1.dateStyle = DateFormatter.Style.short

            let fromDate1 = dateFormatter1.string(from: book.fromDate! as Date)
            let toDate1 = dateFormatter1.string(from: book.toDate! as Date)
            let today = dateFormatter1.string(from: NSDate() as Date)

            if(fromDate1 <= today && toDate1 >= today && (room.roomName==book.room?.roomName)){
                bflag = true;
                booked.append(room)
                break;
            }
        }

        if(!bflag){
            vacant.append(room)
        }
    }
    
    if(booked.isEmpty){
        tempString = tempString + "NO BOOKED ROOMS FOR TODAY!!"
        tempString = tempString + "\n"
    }
    else{
        tempString = tempString + "----------------BOOKED ROOM(S)------------------"
        for r in booked{
            tempString = tempString + "\n" + "ROOM NAME: "+r.roomName!
            tempString = tempString + "\n" + "ROOM TYPE: "+r.roomType!
            tempString = tempString + "\n"
        }
    }

    if(vacant.isEmpty){
        tempString = tempString + "\n" + "NO VACANT ROOMS FOR TODAY!!"
    }
    else{
        tempString = tempString + "\n\n" + "------------------VACANT ROOM(S)--------------------"
        for v in vacant{
            tempString = tempString + "\n" + "ROOM NAME: "+v.roomName!
            tempString = tempString + "\n" + "ROOM TYPE: "+v.roomType!
            tempString = tempString + "\n"
        }
    }
    
    return tempString
}

func containsOnlyLetters(_ input: String) -> Bool {
    if(input.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
        return false
    }
    for chr in input.characters.indices {
        if (!(input[chr] >= "a" && input[chr] <= "z") && !(input[chr] >= "A" && input[chr] <= "Z") && !(input[chr] == " ")) {
            return false
        }
    }
    return true
}

func getCList() -> Array<Customer> {
    return cList
}

//func getRoomList() -> Array<Room> {
//    return rList
//}

func getBookingList() -> Array<Booking> {
    return bList
}

//func getCustById (_ cid:String) -> Customer? {
//    for c in getCList(){
//        if(c.idNumber == cid){
//            return c
//        }
//    }
//    return nil
//}

//func addRoom(_ roomName: String,_ type: roomType,_ price: Int){
//    let room = Room(roomName,type,price)
//    print("Successfully created room",room.roomName + " room type",room.type)
//    rList.append(room)
//}

//func addBooking(_ bookingName: String,_ fromDate: NSDate,_ toDate: NSDate,_ cust: Customer,_ room: Room){
//    let book = Booking(bookingName,fromDate,toDate,cust,room)
//    bList.append(book)
//    print("SUCCESSFULLY BOOKED TO:", book.room.roomName + " ", book.cust.idNumber)
//}

func deletebooking(_ index: Int){
    bList.remove(at: index);
    print("SUCCESSFULLY DELETED BOOKING!!")
}

func preloadData(){
    
    //LOADED CUSTOMER DETAILS
//    addCustomer("CK","8 St. Germain Street","1",8577078609)
//    addCustomer("NL","42 St. Germain Street","2",8577013492)
//    addCustomer("SK","38 St. Germain Street","3",8577013500)
//    addCustomer("AL","42 St. Germain Street","4",8577078832)
//    addCustomer("NM","10 Clearway Street","5",8577078932)
//    addCustomer("SS","South Boston","6",8577078011)
    
    //PRELOADED ROOMS DETAILS
//    var flag:Bool = false;
//    var roomName: String
//    repeat{
//        flag = false
//        roomName = "ROOM" + "".randomNumericString()
//        if(getRoomList().isEmpty){
//            flag = false;
//        }
//        for r in getRoomList(){
//            if (r.roomName == (roomName)){
//                flag = true;
//                break;
//            }
//        }
//    }while(flag)
//    print (roomName)
//    addRoom(roomName,roomType.singleOccupancy,200)
//    repeat{
//        flag = false
//        roomName = "ROOM" + "".randomNumericString()
//        if(getRoomList().isEmpty){
//            flag = false;
//        }
//        for r in getRoomList(){
//            if (r.roomName == (roomName)){
//                flag = true;
//                break;
//            }
//        }
//    }while(flag)
//    addRoom(roomName,roomType.singleOccupancy,200)
//    repeat{
//        flag = false
//        roomName = "ROOM" + "".randomNumericString()
//        if(getRoomList().isEmpty){
//            flag = false;
//        }
//        for r in getRoomList(){
//            if (r.roomName == (roomName)){
//                flag = true;
//                break;
//            }
//        }
//    }while(flag)
//    addRoom(roomName,roomType.doubleOccupancy,400)
//    repeat{
//        flag = false
//        roomName = "ROOM" + "".randomNumericString()
//        if(getRoomList().isEmpty){
//            flag = false;
//        }
//        for r in getRoomList(){
//            if (r.roomName == (roomName)){
//                flag = true;
//                break;
//            }
//        }
//    }while(flag)
//    addRoom(roomName,roomType.doubleOccupancy,400)
//    repeat{
//        flag = false
//        roomName = "ROOM" + "".randomNumericString()
//        if(getRoomList().isEmpty){
//            flag = false;
//        }
//        for r in getRoomList(){
//            if (r.roomName == (roomName)){
//                flag = true;
//                break;
//            }
//        }
//    }while(flag)
//    addRoom(roomName,roomType.singleOccupancy,200)
    
}
