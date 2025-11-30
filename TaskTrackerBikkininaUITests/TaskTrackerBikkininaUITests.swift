//
//  TaskTrackerBikkininaUITests.swift
//  TaskTrackerBikkininaUITests
//
//  Created by Alina Bikkinina on 19.11.2025.
//

import XCTest

final class TaskTrackerBikkininaUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()

        // Дождаться появления экрана задач
        let title = app.staticTexts["Задачи"]
        XCTAssertTrue(title.waitForExistence(timeout: 3.0), "Нет главного экрана")
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }
    
    // MARK: - TEST 1: Создание новой задачи
    func testCreateTask() {
        let app = XCUIApplication()
        app.launch()
        
        let addButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addButton.exists, "Кнопка добавления задачи не найдена")
        addButton.tap()
        
        let titleField = app.textFields["taskTitleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2.0), "Поле заголовка не найдено")
        titleField.tap()
        titleField.typeText("Новая задача")
        
        let descriptionField = app.textViews["taskDescriptionView"]
        XCTAssertTrue(descriptionField.exists, "Поле описания не найдено")
        descriptionField.tap()
        descriptionField.typeText("Описание новой задачи")
        
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists, "Кнопка назад не найдена")
        backButton.tap()
        
        let newTaskCell = app.tables.staticTexts["Новая задача"]
        XCTAssertTrue(newTaskCell.waitForExistence(timeout: 2.0),
                      "Созданная задача не появилась в списке")
    }


    // MARK: - TEST 2: Поиск задачи
    func testSearchTaskByText() {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.searchFields["Поиск"]
        XCTAssertTrue(searchField.exists, "Не найден search bar")

        searchField.tap()
        searchField.typeText("Новая")

        let cell = app.tables.staticTexts["Новая задача"]
        XCTAssertTrue(cell.waitForExistence(timeout: 2.0),
                      "Поиск не нашёл созданную задачу")
    }


    // MARK: - TEST 3: Клавиатура скрывается при тапе по лейблу 'Задачи'
    func testKeyboardDismissesOnTapOutsideSearchBar() {
        let searchField = app.searchFields["Поиск"]
        searchField.tap()

        XCTAssertTrue(app.keyboards.count > 0, "Ожидалась клавиатура")

        app.staticTexts["Задачи"].tap()

        XCTAssertTrue(app.keyboards.count == 0, "Клавиатура не скрылась")
    }

    // MARK: - TEST 3: Открытие детали задачи
    func testOpenTaskDetail() {
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "Нет первой задачи")

        firstCell.tap()

        let detailScreen = app.otherElements["TaskDetailScreen"]
        XCTAssertTrue(
            detailScreen.waitForExistence(timeout: 2.0),
            "Экран деталей не открылся"
        )
    }

    // MARK: - Пример: тест производительности
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
