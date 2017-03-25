%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Shayan Fazeli - 91102171 %
%Image Processing         %
%Fall 2015                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%First, we define the function:
function out = HW1_Q2(input_string)
    %Now we have to know what to process:
    if strcmp(input_string, 'tobolsk.jpg')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Processing 'tobolsk.jpg'%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %In this case, image pyramid is not necessary.
        %We just perform the algorithm:
        three_combined = imread('tobolsk.jpg');
        Blue = three_combined(1:341,:);
        Green = three_combined(342:(342+340),:);
        Red = three_combined(683:(683+340),:);
        
        %Preprocessing:
        Blue(:,1:10)=0;
        Green(:,1:10)=0;
        Red(:,1:10)=0;
        
        Blue(:,end-13:end)=0;
        Green(:,end-13:end)=0;
        Red(:,end-13:end)=0;
        
        Blue(end-5:end,:)=0;
        Green(end-5:end,:)=0;
        Red(end-5:end,:)=0;

        %Using the algorithm below, we "fix" the position of the red frame.
        %Relative to that, we calculate the correct coordinate of the
        %other frames
        FinalRed = [zeros(size(Red,1),40) Red zeros(size(Red,1),40)];
        FinalRed = [zeros(40,size(FinalRed,2)); FinalRed; zeros(40,size(FinalRed,2))];
        %First, the blue color:
        myI = 1;
        myJ = 1;
        D = Inf;
        
        NewBlue = zeros(size(Blue,1)+80, size(Blue,2)+80);
        for i = 1:79
            for j = 1:79
                %In this loop, we will calculate the D and based on that we will
                %decide what position to use.
                NewBlue(j:j+size(Blue,1)-1,:) = [zeros(size(Blue,1),i) Blue zeros(size(Blue,1),80-i)];
                Dnew = sum(sum((double(NewBlue) - double(FinalRed)).^2));
                if(Dnew<D)
                    myI = i;
                    myJ = j;
                    D = Dnew;
                end
                NewBlue = zeros(size(Blue,1)+80, size(Blue,2)+80);
            end
        end
        
        i = myI;
        j = myJ;
        
  
        
        FinalBlue = [zeros(size(Blue,1),i) Blue zeros(size(Blue,1),80-i)];
        FinalBlue = [zeros(j,size(FinalBlue,2));FinalBlue;zeros(80-j,size(FinalBlue,2))];
        
        
        %Now the green:
        
        myI = 1;
        myJ = 1;
        D = Inf;
        
        NewGreen = zeros(size(Green,1)+80, size(Green,2)+80);
        for i = 1:79
            for j = 1:79
                %In this loop, we will calculate the D and based on that we will
                %decide what position to use.
                NewGreen(j:j+size(Green,1)-1,:) = [zeros(size(Green,1),i) Green zeros(size(Green,1),80-i)];
                Dnew = sum(sum((double(NewGreen) - double(FinalRed)).^2));
                if(Dnew<D)
                    myI = i;
                    myJ = j;
                    D = Dnew;
                end
                NewGreen = zeros(size(Green,1)+80, size(Green,2)+80);
            end
        end
        
        i = myI;
        j = myJ;
        FinalGreen = [zeros(size(Green,1),i) Green zeros(size(Green,1),80-i)];
        FinalGreen = [zeros(j,size(FinalGreen,2));FinalGreen;zeros(80-j,size(FinalGreen,2))];
        
        colored_image = cat(3,FinalRed, FinalGreen);
        colored_image = cat(3,colored_image, FinalBlue);
        figure;
        imshow(colored_image);title('colored tobolsk.jpg');
        imwrite(colored_image,'HW1_Q2_tobolsk.jpg');




        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif strcmp(input_string, 'harvesters.tif')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Processing 'harvesters.tif'%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Stage1:
        %First, we take the picture which is a combination of
        %three grayscale pictures, and do some preprocessing to make
        %the final processing easier and more efficient:

        %Reading the picture:
        three_combined = imread('harvesters.tif');
        
        %Performing Preprocess1:
        three_combined(1:140,:)=[];
        three_combined(size(three_combined,1)-140:size(three_combined,1),:)=[];
        three_combined(:,1:100)=[];
        three_combined(:,size(three_combined,2)-120:size(three_combined,2))=[];

        %Then "Image Pyramid" is necessary.
        X_length = floor(size(three_combined,1)/3);
        Y_length = floor(size(three_combined,2)/3);
        Blue = three_combined(1:X_length,:);
        Green = three_combined(X_length+1:2*X_length,:);
        Red = three_combined(2*X_length+1:3*X_length,:);

        %More preprocessing:
        Red(1:40,:)=0;
        Blue(1:40,:)=0;
        
        Green(1:40,:)=0;
        Blue = [zeros(80,size(Blue,2));Blue];
        Blue(end-79:end,:)=[];
        
        %Here we go, first, we'll resize it to 1/8 times
        %the original scale, and, we go forward:
        myI = 40;
        myJ = 40;
        
        [i, j] = best_pos(imresize(Red,0.125),imresize(Blue,0.125),myI,myJ,1);
        myI = 2*i;
        myJ = 2*j;
        
        [i, j] = best_pos(imresize(Red,0.25),imresize(Blue,0.25),myI,myJ,2);
        myI = 2*i;
        myJ = 2*j;
        
        [i, j] = best_pos(imresize(Red,0.5),imresize(Blue,0.5),myI,myJ,4);
        myI = 2*i;
        myJ = 2*j;
        
        [i, j] = best_pos(imresize(Red,1),imresize(Blue,1),myI,myJ,8);
        myI = i;
        myJ = j;
        FinalBlue = [zeros(size(Blue,1),i) Blue zeros(size(Blue,1),640-i)];
        FinalBlue = [zeros(j,size(FinalBlue,2));FinalBlue;zeros(640-j,size(FinalBlue,2))];
        
        
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Green
        
        myI = 40;
        myJ = 40;
        
        [i, j] = best_pos(imresize(Red,0.125),imresize(Green,0.125),myI,myJ,1);
        myI = 2*i;
        myJ = 2*j;
        
        [i, j] = best_pos(imresize(Red,0.25),imresize(Green,0.25),myI,myJ,2);
        myI = 2*i;
        myJ = 2*j;
        
        [i, j] = best_pos(imresize(Red,0.5),imresize(Green,0.5),myI,myJ,4);
        myI = 2*i;
        myJ = 2*j;
        
        [i, j] = best_pos(imresize(Red,1),imresize(Green,1),myI,myJ,8);
        myI = i;
        myJ = j;
        
        FinalGreen = [zeros(size(Green,1),i) Green zeros(size(Green,1),640-i)];
        FinalGreen = [zeros(j,size(FinalGreen,2));FinalGreen;zeros(640-j,size(FinalGreen,2))];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        FinalRed = [zeros(size(Red,1),320) Red zeros(size(Red,1),320)];
        FinalRed = [zeros(320,size(FinalRed,2));FinalRed;zeros(320,size(FinalRed,2))];
        finalimage = cat(3,FinalRed,cat(3,FinalGreen,FinalBlue));
        imshow(finalimage);
        imwrite(uint8(finalimage/(2^8)),'HW1_Q2_harvesters.jpg');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Processing 'settlers.jpg'%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        three_combined = imread('settlers.jpg');
        Blue = three_combined(1:341,:);
        Green = three_combined(342:(342+340),:);
        Red = three_combined(683:(683+340),:);
        
        
        %Blue preprocessing:
        Blue(1:20,:)=0;
        Blue(:,1:13)=0;
        Blue(:,end-12:end)=0;
        
        
        Green(1:10,:)=0;
        Green(:,1:13)=0;
        Green(:,end-12:end)=0;
        
        Red(1:8,:)=0;
        Red(end-9:end,:)=0;
        Red(:,1:13)=0;
        Red(:,end-12:end)=0;
        
        
        
        
        %Using the algorithm below, we "fix" the position of the red frame.
        %Relative to that, we calculate the correct coordinate of the
        %other frames
        FinalRed = [zeros(size(Red,1),40) Red zeros(size(Red,1),40)];
        FinalRed = [zeros(40,size(FinalRed,2)); FinalRed; zeros(40,size(FinalRed,2))];
        %First, the blue color:
        myI = 1;
        myJ = 1;
        D = Inf;
        
        NewBlue = zeros(size(Blue,1)+80, size(Blue,2)+80);
        for i = 1:79
            for j = 1:79
                %In this loop, we will calculate the D and based on that we will
                %decide what position to use.
                NewBlue(j:j+size(Blue,1)-1,:) = [zeros(size(Blue,1),i) Blue zeros(size(Blue,1),80-i)];
                Dnew = sum(sum((double(NewBlue) - double(FinalRed)).^2));
                if(Dnew<D)
                    myI = i;
                    myJ = j;
                    D = Dnew;
                end
                NewBlue = zeros(size(Blue,1)+80, size(Blue,2)+80);
            end
        end
        
        i = myI;
        j = myJ;
        
        
        
        FinalBlue = [zeros(size(Blue,1),i) Blue zeros(size(Blue,1),80-i)];
        FinalBlue = [zeros(j,size(FinalBlue,2));FinalBlue;zeros(80-j,size(FinalBlue,2))];
        
        
        %Now the green:
        
        myI = 1;
        myJ = 1;
        D = Inf;
        
        NewGreen = zeros(size(Green,1)+80, size(Green,2)+80);
        for i = 1:79
            for j = 1:79
                %In this loop, we will calculate the D and based on that we will
                %decide what position to use.
                NewGreen(j:j+size(Green,1)-1,:) = [zeros(size(Green,1),i) Green zeros(size(Green,1),80-i)];
                Dnew = sum(sum((double(NewGreen) - double(FinalRed)).^2));
                if(Dnew<D)
                    myI = i;
                    myJ = j;
                    D = Dnew;
                end
                NewGreen = zeros(size(Green,1)+80, size(Green,2)+80);
            end
        end
        
        i = myI;
        j = myJ;
        FinalGreen = [zeros(size(Green,1),i) Green zeros(size(Green,1),80-i)];
        FinalGreen = [zeros(j,size(FinalGreen,2));FinalGreen;zeros(80-j,size(FinalGreen,2))];
        
        colored_image = cat(3,FinalRed, FinalGreen);
        colored_image = cat(3,colored_image, FinalBlue);
        figure;
        imshow(colored_image);title('colored settlers.jpg');
        imwrite(colored_image,'HW1_Q2_settlers.jpg');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end











%Define best_pos function:
function [i, j] = best_pos(Red, Blue, firstI, firstJ, k)
    %Using the algorithm below, we "fix" the position of the red frame.
    %Relative to that, we calculate the correct coordinate of the
    %other frames
    FinalRed = [zeros(size(Red,1),40*k) Red zeros(size(Red,1),40*k)];
    FinalRed = [zeros(40*k,size(FinalRed,2));FinalRed;zeros(40*k,size(FinalRed,2))];
    
    %First, the blue color:
    myI = 1;
    myJ = 1;
    D = Inf;
    if k == 1
        l = 39;
    else
        l = 5;
    end
    for i = firstI-l:l+firstI
        for j = firstJ-l:l+firstJ
            %In this loop, we will calculate the D and based on that we will
            %decide what position to use.
            
            NewBlue = [zeros(size(Blue,1),i) Blue zeros(size(Blue,1),80*k-i)];
            NewBlue = [zeros(j,size(NewBlue,2));NewBlue;zeros(80*k-j,size(NewBlue,2))];
%             size(NewBlue)
%             size(FinalRed)
             Dnew = sum(sum(double(NewBlue - FinalRed).^2));
             if(Dnew<D)
                 myI = i;
                 myJ = j;
                 D = Dnew;
                 
             end
        end
    end
    
    i = myI;
    j = myJ;
end
