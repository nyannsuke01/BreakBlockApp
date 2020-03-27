//
//  ViewController.swift
//  BleakBlocksApp
//
//  Created by user on 2020/03/24.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ballImage: UIImageView!
    @IBOutlet weak var racketImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet var blocks: [UIImageView]!
    @IBOutlet weak var completeLabel: UILabel!
    //ボールの進むベクトル値
    var vectBall = CGPoint(x: 1, y: 1)
    var ballSpeed = 5
    //消したブロックの数
    var hittedBlockCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
         //ラケットとボールのy軸の値を画面サイズに合わせて設定
         racketImage.center.y = view.bounds.maxY - 100 //bounds.maxYって何
         ballImage.center.y = view.bounds.maxY - racketImage.bounds.maxY - 100
         //ボールスピードタイマー
         Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(MoveBall), userInfo: nil, repeats: true)
         //スピードアップ
         Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ChangeSpeed), userInfo: nil, repeats: true)

     }

     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

         completeLabel.isHidden = true
         let touchevent = touches.first!
         //        let view = touchevent.view!
         let old = touchevent.previousLocation(in: self.view)
         let new = touchevent.location(in: self.view)
         //        view.frame.origin.x += (new.x - old.x)
         //        view.frame.origin.y += (new.y - old.y)
         racketImage.center.x += new.x - old.x
     }

     @objc func ChangeSpeed() {
         vectBall.x *= 1.1
         vectBall.y *= 1.1

     }

     @objc func MoveBall(){
         ballImage.center.x += vectBall.x
         ballImage.center.y -= vectBall.y
         if ballImage.center.x >= view.bounds.maxX - ballImage.bounds.maxX / 2 {
             vectBall.x = vectBall.x * -1
         } else if ballImage.center.x <=  ballImage.bounds.maxX / 2 {
             vectBall.x = vectBall.x * -1
         } else if ballImage.center.y >= view.bounds.maxY - ballImage.bounds.maxY / 2 {
             vectBall.y = vectBall.y * -1
         } else if ballImage.center.y <= ballImage.bounds.maxY / 2 {
             vectBall.y = vectBall.y * -1
         }

         //ラケットとのあたり判定
         if ballImage.center.x + ballImage.bounds.maxX / 2 > racketImage.center.x - racketImage.bounds.maxX / 2 , ballImage.center.x - ballImage.bounds.maxX / 2  < racketImage.center.x + racketImage.bounds.maxX / 2 , ballImage.center.y + ballImage.bounds.maxY / 2 > racketImage.center.y -  racketImage.bounds.maxY / 2 , ballImage.center.y - ballImage.bounds.maxY / 2 < racketImage.center.y -  racketImage.bounds.maxY / 2 , vectBall.y < 0 {
             vectBall.y = vectBall.y * -1
         }

    //ブロックとのあたり判定
    for block in blocks {
        if abs(ballImage.center.x - block.center.x) <
            (ballImage.bounds.width + block.bounds.width) / 2
            , abs(ballImage.center.y - block.center.y) <
            (ballImage.bounds.height + block.bounds.height) / 2
            , !block.isHidden{
            if vectBall.y > 0 {
                vectBall.x = vectBall.x * -1
                vectBall.y = vectBall.y * -1
            } else {
                vectBall.y = vectBall.y * -1
            }
            block.isHidden = true
            hittedBlockCount += 1
                //クリア判定
                if blocks.count == hittedBlockCount {
                completeLabel.isHidden = false
                completeLabel.text = "ゲームコンプリート!🎉"
                ballSpeed = 0
                ballImage.isHidden = true
                }
            }
       }
    }
}

