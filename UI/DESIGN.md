# Subscription Tracker App – Design System (Soft UI Theme)

## 1. Overview
A minimal, soft-colored subscription tracking mobile application focused on:
- Fast data entry
- Clear financial overview
- Clean and calming user experience

Platform: Android (Material Design 3 inspired)  
Style: Soft UI / Pastel / Light Theme  

---

## 2. Color System

### Primary Colors
- Primary: #8FBFA0 (Soft Green)
- Primary Variant: #7AAE8C
- Secondary: #C8B6E2 (Soft Lavender)
- Accent: #F2C6C2 (Soft Coral)

### Backgrounds
- Main Background: #F7F7F5 (Off-white)
- Card Background: #FFFFFF
- Input Background: #F0F0EC

### Status Colors
- Success (Paid): #8FBFA0
- Warning (Upcoming): #E6C48F
- Danger (Overdue): #E8A0A0

### Text Colors
- Primary Text: #2E2E2E
- Secondary Text: #7A7A7A
- Disabled: #BDBDBD

---

## 3. Typography

Font Family:
- Primary: Inter / SF Pro / Roboto

Font Scale:
- Title: 22–26px (Semi-bold)
- Section Header: 16–18px (Medium)
- Body: 14–16px (Regular)
- Caption: 12–13px

---

## 4. Layout & Spacing

- Grid: 8pt system
- Padding:
  - Screen: 16px
  - Card: 12–16px
- Border Radius:
  - Cards: 16px
  - Buttons: 12px
  - Inputs: 10px

---

## 5. Components

### 5.1 Cards (Subscription Item)
- Layout:
  - Left: App icon
  - Middle: Name + renewal date
  - Right: Price + status badge
- Shadow:
  - Soft shadow (low opacity, high blur)

---

### 5.2 Buttons

Primary Button:
- Background: Primary color
- Text: White
- Radius: 12px
- Height: 48px

Secondary Button:
- Background: light grey
- Text: dark

FAB (Floating Action Button):
- Circular
- Color: Primary
- Icon: “+”

---

### 5.3 Inputs

- Background: light grey (#F0F0EC)
- Border: none or very subtle
- Padding: 12px
- Radius: 10px

---

### 5.4 Status Badge

- Paid → Green
- Upcoming → Yellow
- Overdue → Red

Rounded pill style, small font (12px)

---

## 6. Screens

---

### 6.1 Home Screen

Sections:

#### Header
- Title: “My Subscriptions”
- Monthly Total:
  - Large text (₺245.50)
  - Small subtitle: “This month”

#### Upcoming Payments
- Horizontal or vertical list
- Highlight “due in X days”

#### Subscription List
Each item includes:
- Icon
- Name
- Price
- Renewal date
- Status badge

#### FAB
- Bottom right
- Action: Add Subscription

---

### 6.2 Add Subscription Screen

Form Fields:
- Subscription Name (text)
- Price (numeric)
- Billing Cycle (dropdown)
- Renewal Date (date picker)
- Category (optional)

CTA:
- “Save Subscription”

UX:
- Minimal steps
- Large touch areas

---

### 6.3 Subscription Detail Screen

Sections:
- Header (logo + name)
- Info:
  - Price
  - Billing cycle
  - Next payment date

Actions:
- Edit
- Delete

Optional:
- Payment history list

---

### 6.4 Empty State

- Illustration (soft, friendly)
- Text:
  - “No subscriptions yet”
- CTA:
  - “Add your first subscription”

---

### 6.5 Statistics Screen

- Monthly total
- Bar chart (spending over time)
- Category breakdown (pie chart)

---

## 7. UX Principles

- Minimize friction (quick add flow)
- Show financial summary first
- Use color subtly (no harsh contrasts)
- Make interactions thumb-friendly

---

## 8. Motion & Interaction

- Subtle animations (200–300ms)
- Smooth transitions
- Button press → slight scale down
- Card swipe → delete/edit actions

---

## 9. Accessibility

- Contrast ratios readable (text vs background)
- Minimum touch size: 44px
- Avoid overly light text on white

---

## 10. Future Enhancements (Optional)

- Dark mode (soft dark palette)
- AI suggestions (detect unused subscriptions)
- Notifications (payment reminders)
- Bank/SMS integration

---