//
//  Activity View.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI

struct ActivityView: View {
    @StateObject var viewModel = ActivityViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 6) {
                            ForEach(ActivityFilterOption.allCases) { tab in
                                Text(tab.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .frame(width: 100, height: 36)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(
                                                viewModel.selectedFilterTab == tab ? Color.appPrimary : Color.clear
                                            )
                                    )
                                    .foregroundColor(
                                        viewModel.selectedFilterTab == tab ? .appSecondary : .primary
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(
                                                Color(
                                                    viewModel.selectedFilterTab == tab ? .appPrimary : .systemGray4
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                                    .onTapGesture {
                                        viewModel.updateFilter(with: tab)
                                    }
                            }//ForEach
                        }//HStack
                        .padding(.horizontal)
                    }//ScrollView
                    .scrollIndicators(.hidden)
                    .padding(.top, 12)
                    
                    GeometryReader { proxy in
                        ScrollView {
                            if viewModel.filteredNotifications.isEmpty {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Spacer()
                                        Text(viewModel.selectedFilterTab.emptyMessage)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.center)
                                        Spacer()
                                    }//HStack
                                }//VStack
                                .padding()
                                .frame(height: proxy.size.height * 0.9)
                            } else {
                                LazyVStack {
                                    ForEach(viewModel.filteredNotifications) { notification in
                                        VStack {
                                            
                                            if let notificationSender = notification.sender {
                                                if let thread = notification.thread {
                                                    NavigationLink {
                                                        ThreadDetailsView(thread: thread)
                                                    } label: {
                                                        ActivityCellView(
                                                            notification: notification,
                                                            sender: notificationSender
                                                        )
                                                    }
                                                } else {
                                                    ActivityCellView(
                                                        notification: notification,
                                                        sender: notificationSender
                                                    )
                                                }
                                            }
                                        }//VStack
                                        .padding(.vertical, 4)
                                    }//ForEach
                                }//LazyVStack
                            }
                        }//ScrollView
                    }//GeometryReader
                    .scrollIndicators(.hidden)
                }//VStack
                if viewModel.showLoadingSpinner {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        AuthProgressView()
                    }//VStack
                }
            }//ZStack
            .refreshable {
                Task { try await viewModel.fetchNotifications() }
            }//refreshable
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Activity")
                        .bold()
                        .font(.largeTitle)
                        .padding(.top, 8)
                }
            }
        }//NavigationStack
    }
}

#Preview {
    ActivityView()
}
