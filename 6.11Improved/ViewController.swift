//
//  ViewController.swift
//  6.11Improved
//
//  Created by Scores_Main_User on 1/13/21.
//

import UIKit

class ViewController: UIViewController
{
    var viewCounter: Int = 0

    var viewsArray: [UIView] = [UIView]()
    var constraintsArray: [NSLayoutConstraint] = [NSLayoutConstraint]()
    let centerView: UIView = UIView()


    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.run()

    }


    func run()
    {


        self.view.addSubview(self.centerView)

        self.centerView.translatesAutoresizingMaskIntoConstraints = false
        self.centerView.isUserInteractionEnabled = true

        self.centerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.centerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.centerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.centerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true


        createDummyView(superView: self.centerView)


    }


    func createDummyView(superView: UIView)
    {


        for i in 0...3
        {
            let dummyView: UIView = UIView()

            self.viewCounter += 1

            self.viewsArray.append(dummyView)
            superView.addSubview(dummyView)
            addTapGesturesToAView(with: dummyView)

            dummyView.isUserInteractionEnabled = true
            dummyView.translatesAutoresizingMaskIntoConstraints = false
            dummyView.backgroundColor = UIColor.systemTeal


            dummyView.heightAnchor.constraint(equalTo: superView.heightAnchor).isActive = true
            dummyView.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true

            let widthConst: NSLayoutConstraint = dummyView.widthAnchor.constraint(equalTo: superView.widthAnchor, multiplier: 0.25, constant: -1)

            var leadingConst: NSLayoutConstraint

            if i == 0
            {
                leadingConst = dummyView.leadingAnchor.constraint(equalTo: superView.leadingAnchor)
            }
            else
            {
                let previousView = viewsArray[i - 1]
                leadingConst = dummyView.leadingAnchor.constraint(equalTo: previousView.trailingAnchor, constant: 1)

            }

            constraintsArray.append(contentsOf: [widthConst, leadingConst])

            NSLayoutConstraint.activate([widthConst, leadingConst])

        }


    }


    func getWidth() -> CGFloat
    {
        let num: Double = 1.0 / Double(viewCounter)
        return CGFloat(num)
    }


    func addTapGesturesToAView(with myView: UIView)
    {
        let addGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTapGesture(_:)))
        addGesture.numberOfTapsRequired = 2
        myView.addGestureRecognizer(addGesture)

        let deleteGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTapGesture(_:)))
        deleteGesture.numberOfTapsRequired = 1
        myView.addGestureRecognizer(deleteGesture)

        deleteGesture.require(toFail: addGesture)
        deleteGesture.delaysTouchesBegan = true
        addGesture.delaysTouchesBegan = true
    }


    @objc func handleDoubleTapGesture(_ sender: UITapGestureRecognizer)
    {
        self.viewCounter += 1

        if let index: Int = getIndexOfViewTapped(sender: sender)
        {
            print("tapped at \(index)")
            createAndAddNewSubView(at: index)
        }


        print("number of views: \(self.viewCounter)")

    }


    @objc func handleSingleTapGesture(_ sender: UITapGestureRecognizer)
    {

        self.viewCounter -= 1
        if let index: Int = getIndexOfViewTapped(sender: sender)
        {
            print("tapped at \(index)")
            deleteSubView(at: index)
        }


        print("number of views: \(self.viewCounter)")

    }


    func getIndexOfViewTapped(sender: UITapGestureRecognizer) -> Int?
    {
        for (index, v) in viewsArray.enumerated()
        {
            if v === sender.view
            {
                return index
            }
        }
        return nil
    }


    func createAndAddNewSubView(at position: Int)
    {
        let newView: UIView = UIView()


        print("position to insert is \(position + 1)")
        self.viewsArray.insert(newView, at: position + 1)

        self.centerView.addSubview(newView)
        addTapGesturesToAView(with: newView)

        newView.isUserInteractionEnabled = true
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = UIColor.systemTeal

        newView.heightAnchor.constraint(equalTo: self.centerView.heightAnchor).isActive = true
        newView.topAnchor.constraint(equalTo: self.centerView.topAnchor).isActive = true


        adjustX()
    }


    func deleteSubView(at position: Int)
    {

        print("position to delete \(position)")
        let viewToDelete: UIView = self.viewsArray[position]

        if let recognizers = viewToDelete.gestureRecognizers
        {
            for recognizer in recognizers
            {
                viewToDelete.removeGestureRecognizer(recognizer as UIGestureRecognizer)
            }
        }

        self.viewsArray.remove(at: position)
        viewToDelete.removeFromSuperview()

        adjustX()


    }


    func deactivateConstraints()
    {
        for const in constraintsArray
        {
            const.isActive = false
        }
        constraintsArray.removeAll()
    }


    func adjustX()
    {

        if viewsArray.count > 0
        {

            deactivateConstraints()

            var previousView: UIView = viewsArray[0]

            for i in 0..<viewsArray.count
            {
                let currentView: UIView = viewsArray[i]
                var leadingConst: NSLayoutConstraint

                let widthConst: NSLayoutConstraint = currentView.widthAnchor.constraint(equalTo: self.centerView.widthAnchor, multiplier: getWidth(), constant: -1)

                if i == 0
                {
                    leadingConst = currentView.leadingAnchor.constraint(equalTo: self.centerView.leadingAnchor)
                }
                else
                {
                    leadingConst = currentView.leadingAnchor.constraint(equalTo: previousView.trailingAnchor, constant: 1)
                }
                previousView = currentView

                self.constraintsArray.append(contentsOf: [leadingConst, widthConst])
                NSLayoutConstraint.activate([leadingConst, widthConst])
            }

//            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 1.2, delay: 0.1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {finished in print("adjusted!")})

        }
    }

}


