%this is a test for the App_interface - couldn't get AppWSimulink working
% app = App_interface;

classdef LiftTestInterface < matlab.uitest.TestCase
    properties
        App
    end
    
    methods (TestMethodSetup) %creates an app for each test and deletes it after the test is complete 
        function launchApp(testCase)
            testCase.App = App_interface;
            testCase.addTeardown(@delete,testCase.App); 
         end
    end
    
   methods (Test)
        function test_up(testCase) %1a - can move up
            testCase.press(testCase.App.Button_5); %pressing button for 6th floor
            
            testCase.verifyEqual(testCase.App.FloorGauge.Value,5) % verify the spinner moves up to 6/could check cur_floor value instead
        end
        
        function  test_down(testCase) %1b - can move down
            testCase.press(testCase.App.Button_4)%make sure the lift is on a higher floor
            
            testCase.press(testCase.App.Button_2) 
            
            testCase.verifyEqual(testCase.App.FloorGauge.Value,2) %verify the lift moves down
        end 
        
        function test_memory(testCase) %2 - remembers commands 
            testCase.press(testCase.App.Button_2)
            testCase.press(testCase.App.Button_5)%executes them one by one, doesn't store them
            testCase.press(testCase.App.Button_8)
            
            testCase.verifyEqual(testCase.App.FloorGauge.Value,2)
            %how to verify that it has moved to all of those? - moving = 0
        end
        
%         function %2a - opens doors at each floor %2b - clears 'memory'
%         end 
%         function %3a - order commands %3b - ignore repeated commands
%         end 
%         
%         function %4 - doors open when stopped %4a - doors open when open button pressed
%         end
%         
%         function %5 - only moves if doors closed %5a - closes if no obstacle %5b - closes no obst+push button
%         end 
%         
%         function %6 - don't move if no input/backlog
%         end
        
        
    end
end


