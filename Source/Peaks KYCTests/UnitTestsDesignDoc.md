
# Unit Test Design Document for Peaks KYC

## 1. Introduction

This document outlines the design for unit tests for the Peaks KYC application. The goal is to ensure the application's logic is robust, reliable, and free of regressions. This document is intended for developers responsible for writing the unit tests.

## 2. Areas to be Tested

Based on the analysis of the codebase, the following areas have been identified as critical for unit testing:

- **ViewModels:** These contain the core presentation logic of the application.
- **Services:** These handle business logic, such as data loading, validation, and API requests.
- **Models:** While mostly data structures, any logic within them should be tested.
- **Extensions:** Utility extensions that contain logic should be tested.

Views are excluded from unit testing as they are best tested with UI tests.

## 3. Detailed Test Plan

### 3.1. ViewModels

#### 3.1.1. `FormManagerViewModel`

- **`loadDataForSelectedCountry()`:**
    - Test that the `state` transitions correctly: `idle` -> `loading` -> `loaded`.
    - Test that the `state` becomes `error` if the `configLoader` throws an error.
    - Test that the correct fields are created by the `fieldFactory`.
    - Test with different countries, including those with and without pre-populated data.
- **`validateAll()`:**
    - Test that `validate()` is called on all `FieldViewModel`s.
- **`getSummaryItems()`:**
    - Test that the correct summary items are returned based on the `FieldViewModel`s.
- **`getFirstErrorIndex()`:**
    - Test that the correct index is returned when there are errors.
    - Test that `nil` is returned when there are no errors.

#### 3.1.2. `FieldViewModel`

- **`init()`:**
    - Test that the `isReadOnly` property is set correctly based on `preFilledValue`.
- **`displayValue`:**
    - Test that the correct display value is returned for different value types (String, DateComponents, nil).
- **`validate()`:**
    - Test that the `validationService` is called with the correct parameters.
    - Test that the `error` property is updated correctly based on the validation result.

#### 3.1.3. `NavigationViewModel`

- **`navigate(to:)`:**
    - Test that the `navigationPath` is updated correctly.

### 3.2. Services

#### 3.2.1. `ConfigLoaderService`

- **`loadData(for:)`:**
    - Test that the `YAMLConfigLoader` is called with the correct file name.
    - Test that the `APIRequestService` is called when the country has pre-populated data.
    - Test that the correct `LoadResult` is returned.
    - Test error handling when `YAMLConfigLoader` or `APIRequestService` throws an error.

#### 3.2.2. `FieldFactory`

- **`makeFields(from:prefilledValues:)`:**
    - Test that the correct `FieldBuilder` is used for each field type.
    - Test that the correct `prefilledValue` is passed to the builder.
    - Test that the returned `[FormField]` is correct.

#### 3.2.3. `ValidationService`

- **`validate(fieldConfig:value:)`:**
    - Test with various valid and invalid values for each validator type.
    - Test that the correct error message is returned.
    - Test that `nil` is returned for valid values.

#### 3.2.4. `YAMLConfigLoader`

- **`load(_:from:)`:**
    - Test that the correct file is loaded from the bundle.
    - Test that the file is correctly decoded.
    - Test `ServiceError.fileNotFound` is thrown for non-existent files.
    - Test `ServiceError.decodingFailed` is thrown for invalid YAML.

#### 3.2.5. `APIRequestService`

- **`fetchUserProfile(from:)`:**
    - Test that the mock JSON is correctly decoded.
    - This service should be mocked in other tests.

### 3.3. Validation Rules

Each validator (`LengthValidator`, `RegexValidator`, `RequiredFieldValidator`, `ValueRangeValidator`) should be tested independently with a variety of inputs to ensure they work as expected.

### 3.4. Extensions

- **`Date+YearMonthDay`:**
    - Test that the correct `DateComponents` are returned.
- **`DateFormatter+StringFromComponents`:**
    - Test that the correct string is returned from `DateComponents`.
    - Test with `nil` input.

## 4. Mocking Strategy

- **`APIRequestService`:** Create a mock that can return a successful `APIUserProfile` or an error.
- **`YAMLConfigLoader`:** Create a mock that can return a successful `CountryKYCConfig` or an error.
- **`ValidationService`:** Can be used as is, or mocked to test specific validation scenarios in `FieldViewModel`.
- **`FieldBuilder`s:** Create mock builders to test `FieldFactory`.

## 5. Test Structure

Tests should be organized in the `Peaks KYCTests` group, following the same structure as the main application. For example, tests for `FormManagerViewModel` should be in a file named `FormManagerViewModelTests.swift`.

Each test function should follow the Given-When-Then structure.
